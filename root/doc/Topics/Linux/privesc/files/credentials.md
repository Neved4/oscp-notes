# Credential Files

At this point, we need to search the filesystem for potential credentials or useful information that could help escalate privileges. The main directories to check include:

## Directory `/home/`

In **`/home`**, we can find user files that may contain SSH keys, command histories, or database files.

```bash
find /home -type f \( -name "*_history" -o -name "id_rsa" -o -name ".git-credentials" -o -name '*.db' -o -name '*.sqlite' -o -name '*.sqlite3' -o -name "Dockerfile" -o -name "docker-compose.yml" \) 2>/dev/null
```

It’s also a good idea to search for filenames and file contents containing the word _"passwd"_.

```bash
# Search by filename
find /home -exec ls -lad $PWD/* "{}" 2>/dev/null \; | grep -i -I "passw\|pwd"

# Search by file content
grep --color=auto -rnw /home -iIe "PASSW\|PASSWD\|PASSWORD\|PWD" --color=always 2>/dev/null
```

## Directory `/etc/`

We need to check system configuration files for stored or misconfigured credentials.

- **`/etc/passwd`**: Typically does not contain password hashes, but it’s worth checking.

  ```bash
  grep -v '^[^:]*:[x\*]' /etc/passwd /etc/pwd.db /etc/master.passwd /etc/group 2>/dev/null
  ```

- **`/etc/shadow`**: Contains password hashes and should not be readable. Also, check for accessible backups or alternate versions.
- **`/etc/sudoers`**: Defines sudo permissions and should not be readable, but there could be accessible copies.

  ```bash
  cat /etc/shadow /etc/shadow- /etc/shadow~ /etc/gshadow /etc/gshadow- /etc/master.passwd /etc/spwd.db /etc/security/opasswd /etc/sudoers 2>/dev/null
  ```

## Directory `/var/www/`

If the system hosts websites, this is where we’ll usually find related files. The most valuable ones are typically database configuration files.

```bash
grep --color=auto -rnw /var/www/ -iIe "PASSW\|PASSWD\|PASSWORD\|PWD" --color=always | grep -v ".js" 2>/dev/null
```

If database credentials are found, they should be tested against system users and services, including `root`. It’s also worth checking the database itself for stored credentials.

Other interesting files include server configurations (`.htpasswd`) or potentially sensitive text files, scripts, or compressed archives.

```bash
find /var/www/ -type f \( -name "*.txt" -o -name "*.sh" -o -name "*.zip" -o -name "*.7z" -o -name "*.gz" -o -name "*.tar.gz" -o -name "*.htpasswd" \) 2>/dev/null
```

## Directory `/var/backups/`

We should check this directory for backups with misconfigured permissions that might contain sensitive information.

## Directories `/var/mail/` & `/var/spool/mail/`

These directories store local user mailboxes. By default, users should only have access to their own, but a misconfiguration could expose sensitive data.

## Directory `/var/log/`

System and service logs are stored here. In some cases, a misconfiguration might allow access to sensitive data.

```bash
grep -RE 'comm="su"|comm="sudo"' /var/log* 2>/dev/null
```

## Other Directories to Check

- **`/tmp`, `/var/tmp`**: Temporary directories where users may leave files with improper permissions.
- **`/opt`**: Contains additional software or scripts, which may lack the security restrictions applied to system binaries.
- **Non-standard root-level directories.**

## General Credential Search

**Search for filenames containing _`passwd`_:**

```bash
find . -exec ls -lad $PWD/* "{}" 2>/dev/null \; | grep -i -I "passw\|pwd"
```

**Search inside files for password-related keywords:**

```bash
grep --color=auto -rnw -iIe "PASSW\|PASSWD\|PASSWORD\|PWD" --color=always 2>/dev/null
```
