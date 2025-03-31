#!/bin/sh
# set -Cefu

## Need to setup the pentesting extensions on my Firefox in kali
## Need to setup the pentesting bookmarks profile either on my FF or Chromium in kali

# shellcheck disable=SC3028
os="${OSTYPE:-$(uname -s)}"
arch=$(uname -m)
escReset='' escRed='' escGreen=''
scriptDir="${0%/*}"

errRoot() { fmtErr 'This script must be run as root.'; }
 fmtErr() { printLn "${escRed}error${escReset}: $*"; }
 hasCmd() { command -v "$1" >/dev/null; }
 isRoot() { [ "$(id -u)" -ne 0 ] && errRoot && exit 1; }
 isTerm() { [ -t 1 ] && escReset='\033[0m' escRed='\033[31m' escGreen='\033[31m'; }
printLn() { printf '%b\n' "$@"; }

configTerminator() {
	dir="$HOME/.config/terminator/"
	file="$HOME/.config/terminator/config"

	mkdir -p "$dir" && touch "$file"

echo '[profiles]
  [[default]]
    scrollback_lines = 90000
    scrollback_infinite = True
' > "$file"
}

getLibrewolf() {
	sudo apt update && sudo apt install extrepo -y
	sudo extrepo enable librewolf
	sudo apt update && sudo apt install librewolf -y
}

aptClean() {
	apt autoremove -y && apt autoclean -y
}

aptUpdate() {
	apt update -y && sudo apt full-upgrade -y
}

brewClean() {
	hasCmd brew && brew autoremove && brew cleanup -s && rm -rf "$(brew --cache)"
}

brewGet() {
	urlBrew=https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh

	/bin/bash -c "$(curl -fsSL "$urlBrew")"
}

brewUpdate() {
	brew update && brew upgrade --greedy-auto-updates
}

nixGet() {
	curl -L https://nixos.org/nix/install | sh --daemon
}

nixDeps() {
	nix-env -iA nixpkgs.chezmoi nixpkgs.gopass nixpkgs.rustscan \
		nixpkgs.rustcat nixpkgs.sniffnet nixpkgs.starship nixpkgs.monaspace \
		nixpkgs.meslo-lg
}

fishUpdate() {
	fish -c 'fish_update_completions'
}

tldrUpdate() {
	tldr --update
}

handleErr() {
	errorOut=$("$@" 2>&1 >/dev/null) exitCode=$?

	if [ "$exitCode" -ne 0 ]
	then
		fmtErr "Error running '$*': $errorOut"
	fi

	return "$exitCode"
}

pkgBrew() {
	pkgBrew="$scriptDir"/oscp.rb

	brewGet && brewUpdate && brew bundle "$pkgBrew"
}

depsGet() {
	# shellcheck disable=SC2046
	apt install $(aptDeps)

	pkgBrew="$scriptDir"/oscp.rb
	pkgApt
	pkgNix

	case $arch in
	amd64|x86_64)
		pkgBrew ;;
	arm64|aarch64)
		nix ;;
		# curlDeps ;;
	esac
}

isLinux() {
	case $os in
	[Ll]inux*) ;;
	*) logger -p user.error -s "$os is not supported" ;;
	esac
}

main() {
	isTerm
	isLinux
	isRoot

	for i in aptUpdate depsGet aptClean brewClean fishUpdate updatedb
	do
		case $i in
		 aptUpdate) msg='Updating apt packages'     ;;
		   depsGet) msg='Getting dependencies'      ;;
		  aptClean) msg='Cleaning apt packages'     ;;
		 brewClean) msg='Cleaning brew packages'    ;;
		fishUpdate) msg='Updating fish completions' ;;
		  updatedb) msg='Updating mlocate database' ;;
		esac

		printf '%b' "$msg... "

		"$i" && printLn "${escGreen}ok${escReset}" && continue

		printLn "${escRed}err${escReset}"
	done

	nodocker=/etc/containers/nodocker
	if hasCmd podman && [ -f $nodocker ]
	then
		sudo touch $nodocker
	fi
}

# sudo update-alternatives --config x-terminal-emulator
# main "$@"
