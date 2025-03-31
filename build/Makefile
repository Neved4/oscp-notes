.POSIX:

all:

build:
	deno fmt --line-width 9000 .
	python3 private/sort_tags.py

serve:
	npx quartz build --serve
	# https://glitch.com/
