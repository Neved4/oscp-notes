---
tags:
- pkg/nix
- tools/core
url: https://github.com/bouk/babelfish
---

## Translating functions

[babelfish](https://github.com/bouk/babelfish) is a utility to translate `bash` scripts to `fish`.

We'll use it to keep our red team functions and aliases in sync, so we can have them autosuggested in `fish`, while have them available through `bash`, `zsh` and other shells.

For that purpose, we'll place our pen-testing functions under `~/.config/sh/syncFunc.sh`:

```bash
getIP() {
	ifconfig | grep 'inet ' | grep -v '127.0.0.1' |
		awk '{ print $2 }' | head -n1
}
```

Then we translate our `sh` code into `fish` code:

```bash
babelfish < ~/.config/sh/syncFunc.sh > ~/.config/fish/syncFunc.fish
```

We can now see the conversion result at `~/.config/sh/syncFunc.sh`:

```fish
function getIP
  ifconfig | grep 'inet ' | grep -v '127.0.0.1' | awk '{ print $2 }' | head -n1
end
```

We source the `syncFunc` file in our `~/.config/fish/config.fish`:

```fish
source ~/.config/fish/syncFunc.fish
```

Profit!

## References

- [blog.fidelramos.net – Migrating to fish shell](https://blog.fidelramos.net/software/fish-shell)
