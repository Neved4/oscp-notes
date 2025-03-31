## Sudo/Admin Group

This group is associated with the `sudo` command, which allows users to execute commands with elevated privileges. An attacker may attempt to add themselves to this group or exploit the permissions granted to its members to access sensitive system functions.

Privilege escalation typically requires knowledge of the user's password.

### Attack

Privilege escalation is often straightforward in this case. In the default Linux configuration, members of the `sudo` and `admin` groups can directly elevate privileges using the following command:

```bash
sudo su
```

If the default configuration has been altered, `pkexec` can be used to execute commands as root, as these groups are typically included in the default policy for this tool:

```bash
pkexec "/bin/sh"
```
