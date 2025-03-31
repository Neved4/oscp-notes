#!/bin/sh

hasCmd() {
	command -v "${1:?}" >/dev/null
}

pbcopyCmd() {
	for cmd in pbcopy xclip xsel
	do
		hasCmd "$cmd" && break
	done

	case "$cmd" in
	pbcopy)
		pbcopy ;;
	xsel)
		xsel --clipboard --input ;;
	xclip)
		xclip -selection clipboard ;;
	*)
		;;
	esac
}

extractPorts() {
	awk '{
		ports = ""
		while (match($0, /([0-9]{1,5})\/open/)) {
			ports = ports (length(ports) ? "," : "") \
				substr($0, RSTART, RLENGTH-5)
			$0 = substr($0, RSTART + RLENGTH)
		}
		if (ports) print ports
	}' "$1"
}

getPorts() {
	file="${1:?}"
	ports=$(extractPorts "$file")

	printf '%s\n' "$ports" | tee /dev/tty | tr -d '\n' # | pbcopyCmd
}

getPortsVerbose() {
	file="${1:?}"
	ports=$(extractPorts "$file")
	ip_addr=$(awk '/^Host:/ {print $2; exit}' "$file")

	printf '%s\n' "[*] Extracting information..." \
		"[*] IP address: $ip_addr" \
		"[*] Open ports: $ports" \
		"[*] Ports copied to clipboard."

	printf '%s\n' "$ports" | tr -d '\n' | pbcopyCmd
}

getPortsBloat() {
	usage() {
		printf "Usage: %s: [-v] filename ...\n" "$0"
	}

	vflag=false

	while getopts "v" opt
	do
		case $opt in
		v)
			vflag=true ;;
		?)
			usage && exit 2 ;;
		esac
	done

	shift $((OPTIND - 1))

	if [ -z "$1" ]
	then
		printf "error: No input file provided.\n" >&2
		usage
		exit 1
	fi

	file="$1"
	ports=$(extractPorts "$file")
	ip_addr=$(awk '/^Host:/ {print $2; exit}' "$file")

	if $vflag
	then
		printf '%s\n' "[*] Extracting information..." \
			"[*] IP address: $ip_addr" \
			"[*] Open ports: $ports" \
			"[*] Ports copied to clipboard."

		printf '%s\n' "$ports" | tr -d '\n' # | pbcopyCmd

		return 0
	fi

	printf '%s\n' "$ports" | tee /dev/tty | tr -d '\n' #| pbcopyCmd
}
