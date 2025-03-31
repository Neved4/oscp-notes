#!/bin/sh

convertPorts() {
	tcp='/proc/net/tcp'

	[ -f $tcp ] && awk '/[0-9]: / {
		split($2, arr, ":")
		print strtonum("0x" arr[2])
	}' $tcp
}

convertPorts
