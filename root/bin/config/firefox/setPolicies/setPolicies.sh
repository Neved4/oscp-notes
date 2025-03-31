#!/bin/sh

: "${escReset:=}" "${escRed:=}"

errMsg() {
    printf '%b: %s\n' "${escRed}error${escReset}" "${1:?}" >&2
    exit 1
}

getConfigFile() {
    configPath="${XDG_CONFIG_HOME:-$HOME/.config}/firefox/extensions.conf"
    localFile='./extensions.conf'

    [ -f "$localFile"  ] && printf '%s\n' "$localFile"  && return 0
    [ -f "$configPath" ] && printf '%s\n' "$configPath" && return 0

    case "${shortConfig:=$configPath}" in
        "$HOME"/*) shortConfig="~${shortConfig#"$HOME"}";;
    esac

    errMsg "${localFile#./} not found in working dir or ${shortConfig%/*}"
}

getMacApp() {
    mdfind "kMDItemKind == 'Application' && kMDItemFSName == '${1:?}.app'"
}

getDarwinPath() {
    browserName=${1:-"LibreWolf"}
    browserPath=$(getMacApp "$browserName")
    distPath='Contents/Resources/distribution'

    [ -z "$browserPath" ] && errMsg "browser not found -- $browserName"

    printf '%s\n' "$browserPath/$distPath/policies.json"
}

getLinuxPath() {
    linuxPaths='/usr/share/firefox-esr /usr/share/firefox /usr/lib/firefox \
/usr/lib/librewolf /usr/share/librewolf'

    for dir in $linuxPaths
    do
        if [ -d "$dir" ]
        then
            printf '%s\n' "$dir/distribution/policies.json"
            return 0
        fi
    done

    errMsg "no supported browser installation found"
}

parseURLs() {
    configFile=${1:?}
    baseUrl='https://addons.mozilla.org/firefox/downloads/latest'

    [ ! -f "$configFile" ] && errMsg "config file does not exist -- $configFile"

    sed '/^\s*#/d; /^\s*$/d' "$configFile" |
        while IFS= read -r line
        do
            case "$line" in
            *.xpi) printf '%s\n' "$line" ;;
                *) printf '%s/latest.xpi\n' "$baseUrl/$line" ;;
            esac
        done
}

getTargetFile() {
    browserName=${1:-"LibreWolf"}

    # shellcheck disable=SC3028
    osName=${OSTYPE:-"$(uname -s)"}

    case $osName in
    [Dd]arwin*) targetFile=$(getDarwinPath "$browserName") || exit 1 ;;
     [Ll]inux*) targetFile=$(getLinuxPath) || exit 1 ;;
             *) errMsg "system not supported -- $osName"
    esac

    printf '%s\n' "$targetFile"
}

hasJq() {
    for cmd in jaq gojq jq
    do
        if command -v "$cmd" >/dev/null
        then
            jqCmd="$cmd"
            return 0
        fi
    done

    errMsg "no supported JSON CLI found (jaq, gojq, jq)"
}

hasSponge() {
    command -v sponge >/dev/null || errMsg "command not found -- sponge"
}

main() {
    hasJq
    hasSponge

    browserName=${1:-"LibreWolf"}
    configFile=$(getConfigFile) \
        || exit 1
    urls=$(parseURLs "$configFile" | $jqCmd -R -s -c 'split("\n")[:-1]') \
        || exit 1
    targetFile=$(getTargetFile "$browserName") \
        || exit 1

    [ ! -f "$targetFile" ] && errMsg "file does not exist -- $targetFile"

    # shellcheck disable=SC2016
    $jqCmd --argjson ext "$urls" '.policies.Extensions.Install |= (
        (. // []) += $ext | unique )' "$targetFile" | sponge "$targetFile"
}

main "$@"
