#!/bin/sh

head='192.168.1'
hostStart='1'
hostEnd='254'
ports='21 22 23 25 80 139 443 445 8080'

cnorm() { printf '%b' '\033[?25h'; }
civis() { printf '%b' '\033[?25l'; }

println() {
	printf '%b\n' "$@"
}

ctrlC() {
	println '\n\n[!] Exiting... '
	cnorm
	exit 1
}

civis
trap ctrlC INT

for i in $(seq $hostStart $hostEnd)
do
	timeout 1 sh -c "ping -c 1 $head. $i" > /dev/null 2>&1 &&
		println "[+] Host $head.$i - ACTIVE" &
done

for j in $(seq $hostStart $hostEnd)
do
	for port in $ports
	do
		timeout 1 sh -c "echo '' > /dev/tcp/$head.$j" 2>/dev/null &&
			println "[+] Host $head.$j/$port - Port $port (OPEN)" &
	done
done

wait
cnorm
