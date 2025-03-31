#!/bin/sh

escReset=''
escRed=''
escGreen=''

if [ -t 1 ]
then
	escReset='\033[0m'
	escRed='\033[31m'
	escGreen='\033[32m'
fi

println() {
	printf '%b\n' "$@"
}

ctrlC() {
	println '\n\n[!] Exiting... '
	exit 1
}

trap ctrlC INT

checkPort() {
	# shellcheck disable=SC3025
	(exec 3<> /dev/tcp/"$1"/"$2") 2>/dev/null
	exit=$?

	if [ $exit -eq 0 ]
	then
		println "${escGreen}[+]$escReset Host $1 - Port $2 (OPEN)"
	fi

	exec 3<&-
	exec 3>&-
}

main() {
	ports=$(seq 1 65535)

	if [ -n "$1" ]
	then
		for port in $ports
		do
			(checkPort "$1" "$port" &)
		done
	else
		println "\n${escRed}[!]$escReset usage: $0 <IP ADDRESS>"
	fi

	wait
}

main "$@"
