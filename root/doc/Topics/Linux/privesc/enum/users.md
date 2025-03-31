# System Users

## User Enumeration

List users with an interactive shell.

```bash
cat /etc/passwd | grep "sh$"
```

Enumerate users and their associated groups.

```bash
echo
while IFS=: read -r username _ uid _ _ hom term
do
	printf '%s\n' '   [>] $username \tHome: $hom \tTerm: $term'
	printf '         Groups:'
	printf '       '
	groups $username | cut -d ' ' -f3- | xargs -n1 echo -n " "
	printf '\n'
done < <(cat /etc/passwd | grep "sh$")
```

## User Session Information

Show currently logged-in users.

```bash
w
```

Display the last active sessions.

```
last | tail
```

## System Group Information

Retrieve a list of groups and their members.

```bash
for group in $(cut -d: -f1 /etc/group)
do
	members=$(getent group $group | cut -d: -f4)
	echo " - $group : $members"
done
```
