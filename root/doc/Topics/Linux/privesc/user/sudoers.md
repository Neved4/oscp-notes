## Sudoers

In the privilege escalation process, the first step should be to check the permissions assigned to the user in the `sudoers` file.

The **`/etc/sudoers`** file contains the security configuration in Unix-based systems that defines which users can execute which commands with root privileges using the `sudo` command. This file has its read permissions limited to the root user, but if the user is present in the configuration, it can list the commands they are allowed to run.

It is also important for an attacker to understand the syntax of the configuration and potential vulnerabilities that could lead to privilege escalation.

## Verification

Use the following command to check the privileges, you may need the user's credentials to view it.

```bash
sudo -l
```

## Attack

With the results from the previous command, there are several aspects to pay attention to in order to identify potential privilege escalation vectors:

### System Binaries for Elevation

Check if the binary being executed is a standard binary that could be leveraged to gain elevated privileges. [[GTFObins]] provides a detailed list of common binaries and their potential uses for privilege escalation.

### Misconfigured Permissions

Review the permissions of the binary and the directory containing it to determine if they can be manipulated by the user to achieve the execution of arbitrary code with elevated privileges.

### sudoers `PATH` Variable

Analyze the **`PATH`** variable used in `/etc/sudoers` and check if it is possible to modify any of the directories present in `PATH`. This could allow the implantation of a malicious binary and execute arbitrary code with elevated privileges.

### `ENV_KEEP` and `SETENV` Modifiers

Sudo typically cleans the user's environment variables, but sometimes, with the use of `ENV_KEEP`, it’s possible to specify which environment variables should be preserved. Another interesting parameter to keep in mind is `SETENV`, which allows the user to retain all environment variables when executing sudo with the `-E` option. These modifiers enable attacks like modifying the `PYTHONPATH` or even forcing the loading of libraries with (`LD_PRELOAD` & `LD_LIBRARY_PATH`) to easily execute malicious code.
