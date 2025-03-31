## Wheel Group

This group is associated with the ability to execute commands with superuser privileges using the **`su`** (switch user) command on Unix/Linux systems. Traditionally, the `wheel` group is used to grant superuser privileges to certain users, allowing them to switch to the root account.

It's important to note that privilege escalation typically requires knowing your own user password.

## Attack

Privilege escalation is usually the simplest in this case, as in the default Linux configuration, the `wheel` group typically has direct access to escalate privileges using the following command.
