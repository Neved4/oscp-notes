# Interesting Files

It is a good practice to review the permissions and non-standard characteristics within the system, as they can point to potential vectors for obtaining sensitive information or even provide a privilege escalation opportunity.

## Writable Files

Find files that belong to the user but can be written by any user:

```bash
find / '(' -type f -or -type d ')' '(' '(' -user $USER ')' -or '(' -perm -o=w ')' ')' 2>/dev/null | grep -v '/proc/' | grep -v $HOME | sort | uniq
```

Find files writable by any group the user belongs to:

```bash
for g in $(groups); do find \( -type f -or -type d \) -group $g -perm -g=w 2>/dev/null | grep -v '/proc/' | grep -v $HOME; done
```

## Files with Unusual Permissions

Find root-owned files in `/home/`:

```bash
find /home -user root 2>/dev/null
```

Find files owned by other users in my directories:

```bash
for d in $(find /var /etc /home /root /tmp /usr /opt /boot /sys -type d -user $(whoami) 2>/dev/null)
do
	find $d ! -user $(whoami) -exec ls -l {} \; 2>/dev/null
done
```

Find root-owned files that are only readable by the user:

```bash
find / -type f -user root ! -perm -o=r 2>/dev/null
```

Find files belonging to the user or writable by everyone:

```bash
find / '(' -type f -or -type d ')' '(' '(' -user $USER ')' -or '(' -perm -o=w ')' ')' ! -path "/proc/*" ! -path "/sys/*" ! -path "$HOME/*" 2>/dev/null
```

Find files that can be modified by the user's group:

```bash
for g in $(groups); do printf "Group $g:\n"; find / '(' -type f -or -type d ')' -group $g -perm -g=w ! -path "/proc/*" ! -path "/sys/*" ! -path "$HOME/*" 2>/dev/null; done
```

## Recently Modified Files

Find files modified in the last 15 minutes:

```bash
find / -type f -mmin -15 ! -path "/proc/*" ! -path "/sys/*" ! -path "/run/*" ! -path "/dev/*" ! -path "/var/lib/*" 2>/dev/null
```

## Suspicious Files

When a file is placed by a package manager, the last digit of its timestamp is typically zero, and if manually modified, it will have an actual timestamp. You can filter to find files that have been tampered with that should not be in the `$PATH`.

```bash
for i in $(echo $PATH | tr ":" "\n")
do
	find $i -type f -exec ls -lda --time-style=full {} \; 2>/dev/null | grep -v "000000\|->"
done
```
