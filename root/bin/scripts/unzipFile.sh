#!/bin/sh

ctrlC() {
	printf '%b\n' "\n\n[!] Saliendo...\n"
	exit 1
}

trap ctrlC INT

infile="data.gz"
outfile="$(7z l data.gz | tail -n 3 | head -n 1 | awk 'NF{print $NF}' )"

7z x $infile >/dev/null 2>&1

while [ -n "$outfile" ]
do
	printf '%b\n' "[+] Nuevo archivo descomprimido: $outfile"

	7z x "$outfile" >/dev/null 2>&1
	outfile="$(7z l "$outfile" | tail -n 3 | head -n 1 | awk 'NF{print $NF}' )"
done
