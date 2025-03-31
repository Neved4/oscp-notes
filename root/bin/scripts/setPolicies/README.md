![Shell Script](https://img.shields.io/badge/Shell_Script-9DDE66?logo=gnubash&logoColor=000&style=flat)
[![POSIX.1-2024](https://img.shields.io/badge/POSIX.1&#8209;2024-00629B?logo=ieee&logoColor=fff&style=flat)][POSIX.1-2024]

# `setPolicies.sh` - Firefox/LibreWolf Extensions Installer

Shell script to configure and install Firefox or LibreWolf extensions from a list defined in `extensions.conf`.

## Motivation

One could do either copy the `policies.json` like:

```sh
jsonFile='/usr/share/firefox-esr/distribution/policies.json'

jq '.policies.Extensions = {
    "Install": [
        "https://addons.mozilla.org/firefox/downloads/latest/wappalyzer/latest.xpi",
        "https://addons.mozilla.org/firefox/downloads/latest/web-clipper-obsidian/latest.xpi",
    ]
}' $jsonFile | sponge $jsonFile
```

Or curl:
```sh
curl -L https://github.com/username/repository/raw/branch/filename.txt -o filename.txt
```

## Highlights

- Reads extension identifiers or `.xpi` URLs from a configuration file.
- Supports both XDG_CONFIG_HOME or configuration files in the current directory.
- Updates the browser’s `policies.json` automatically in both macOS or Linux.
- Prevents duplicate entries when updating `policies.json`.
- Converts Firefox add-on IDs into the correct Mozilla download URLs automatically.

## Getting Started

### Prerequisites

- A [POSIX.1-2024] compliant shell
- [`jq`]() or another command-line JSON processor ([`jaq`](), [`gojq`]())
- [`sponge`](), from `moreutils`

### Installation

Clone the repository and make the script executable:

```sh
git clone https://github.com/YourUser/setPolicies.sh
cd setPolicies.sh
chmod +x install-extensions.sh
```

Install dependencies:

**Debian/Ubuntu:**
```sh
sudo apt install jq moreutils
```

**macOS (Homebrew):**
```sh
brew install jq moreutils
```

### Usage

`setPolicies.sh` can be invoked in the following ways:
```sh
./install-extensions.sh LibreWolf
```

The following options are available:

```
usage: ./install-extensions.sh [BrowserName]

Options:
    BrowserName
        Optional. Specify either LibreWolf or Firefox.
        Defaults to LibreWolf.

Environment:
    XDG_CONFIG_HOME
        Specifies the base path for extensions.conf.
        Defaults to $HOME/.config/firefox/extensions.conf.
```

### Configuration

**File format:**

- Lines starting with `#` or empty lines are ignored
- Each line can be either:
  - Full `.xpi` URL
  - Firefox add-on ID (e.g., `uBlock0@raymondhill.net`)

**Example `extensions.conf`:**
```sh
# Shorthand
ublock-origin

# Mozilla Store
https://addons.mozilla.org/firefox/downloads/ublock-origin/latest.xpi
```

### Behavior

- The script will read `extensions.conf` from either the current directory or `$XDG_CONFIG_HOME/firefox/extensions.conf`.  
- It will update `policies.json` in the appropriate location depending on OS:  
  - macOS: uses `mdfind` to locate the browser and updates `Contents/Resources/distribution/policies.json`.  
  - Linux: checks common paths (`/usr/lib/firefox`, `/usr/share/librewolf`, etc.) and updates `distribution/policies.json`.  
- Duplicate extensions are automatically removed.  
- Add-on IDs are converted to Mozilla download URLs.

## Standards & Portability

Conforms to [POSIX.1-2024].

- macOS: automatically finds the browser using `mdfind`  
- Linux: checks standard installation paths  

Other platforms are not supported.

## License

Released under the [MIT License]. See [LICENSE](LICENSE) for details.

## References

[policy-templates | Policy Templates for Firefox](https://mozilla.github.io/policy-templates/)  

[POSIX.1-2024]: https://pubs.opengroup.org/onlinepubs/9799919799/
[MIT License]: https://opensource.org/license/mit/
