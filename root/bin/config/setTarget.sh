#!/bin/sh

setTarget() {
    target=${1:?'usage: setTarget <ip>'}

    pattern="export target=$target"
    re="s|^export target=.*|$pattern|"

    for file in "$HOME/.bashrc" "$HOME/.zshrc"
    do
        [ -f "$file" ] || continue

        if grep -q '^export target=' "$file" 2>/dev/null
        then
            {
              sed --version >/dev/null 2>&1 &&
              sed -i "$re" "$file"
            } || sed -i '' "$re" "$file"
        else
            printf '\n%s\n' "$pattern" >> "$file"
        fi
    done

    export target="$target"

    printf 'Target updated to: %s\n' "$target"
}

setTarget "${1:?}"
