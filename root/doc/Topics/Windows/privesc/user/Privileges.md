# User Privileges

In the first step, the various privileges assigned to the user will be checked to determine if any actions that could aid privilege escalation are possible. For more detailed information, reviewing the [Priv2Admin project](https://github.com/gtworek/Priv2Admin) on GitHub may be beneficial.

## Check

Use the following command to check the privileges. It's important to note that even if they appear as disabled in the output, it does not mean the user lacks them.

```batch
whoami /priv
```

Dangerous privileges that an attacker may exploit for privilege escalation include the following:

- [SeAssignPrimaryTokenPrivilege]()
- [SeImpersonatePrivilege]()
- [SeBackupPrivilege]()
- [SeRestorePrivilege]()
- [SeTakeOwnershipPrivilege]()
- [SeCreateTokenPrivilege]()
- [SeDebugPrivilege]()
- [SeLoadDriverPrivilege]()
- [SeTcbPrivilege]()
- [SeManageVolumePrivilege]()
