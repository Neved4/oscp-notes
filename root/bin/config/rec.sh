#!/bin/sh

startRecord() {
	timeStamp=$(date +"%F_%Y-%m-%d%z")
	script -r "${timeStamp}_script.log"
	script -r "${timeStamp}_script_above.log" asciinema rec "$timeStamp.cast"
	script -dp "${timeStamp}_script_dp.log" > "$timeStamp.log"
}

replayScript() {
	script -p "$1"
}

replayAsciinema() {
	asciinema play "$1"
}

replayLastScript() {
	# shellcheck disable=SC2012
	lastLogFile=$(ls -Art ./*.script | tail -n1)

	[ -n "$lastLogFile" ] && replayScript "$lastLogFile"
}

replayLastAsciinema() {
	# shellcheck disable=SC2012
	lastCastFile=$(ls -Art ./*.cast | tail -n1)

	[ -n "$lastCastFile" ] && replayAsciinema "$lastCastFile"
}

replayLast() {
	replayLastScript
}
