#!/bin/sh

# https://github.com/s0md3v/Smap
# https://github.com/bee-san/RustScan

urlGithubRaw='https://raw.githubusercontent.com/'
urlGithubApi='https://api.github.com'

  debLatest() { url=$1 && curl -s "$url" | debFilter; }

rustcatGet() {
	urlRustcat="$urlGithubRaw/robiot/rustcat/master/pkg/debian-install.sh"

	hasCmd rustcat || curl -s "$urlRustcat" | bash
}

rustcanGet() {
	urlRustscan="$urlGithubApi/repos/RustScan/RustScan/releases/latest"

	command -v rustscan || curl -L -o rustscan.deb "$(debLatest "$urlRustscan")"
}

starshipGet() {
	urlStarship='https://starship.rs/install.sh'

	hasCmd starship || curl -sS "$urlStarship" | sh -s -- -y
}

chezmoiGet() {
	urlChezmoi='get.chezmoi.io'

	hasCmd chezmoi || sh -c "$(curl -fsLS $urlChezmoi)"
}

gopassGet() { wget https://github.com/gopasspw/gopass/releases/download/v1.15.14/gopass_1.15.14_linux_amd64.deb; sudo dpkg -i gopass_1.15.14_linux_amd64.deb; }


debFilter() {
	if hasCmd jq
	then
		jqFilter
		return 0
	fi

	shFilter
}

jqFilter() {
	jq -r '.assets[] | select(.name | test(".*_amd64.deb$")) |
		.browser_download_url'
}

shFilter() {
	grep -o '"browser_download_url": *"[^"]*amd64.deb"' |
		sed 's/"browser_download_url": "//' | sed 's/"$//'
}

curlDeps() {
	rustcatGet
	# rustscanGet
	starshipGet
}
