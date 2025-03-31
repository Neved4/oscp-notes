## User Groups

The second step is to check the groups to which the user belongs. This check is extremely important because some of these groups might represent direct paths for privilege escalation.

## Check

Use the following command to check the groups the user belongs to.

### Example

```batch
whoami /groups
```

The groups with privileges that an attacker can leverage for privilege escalation are the following:

- [Administrators, Domain Admins, Enterprise Admins](https://daniel10barredo.github.io/PrivEscAssist_Windows/#groups/Admins)
- [Backup Operators](https://daniel10barredo.github.io/PrivEscAssist_Windows/#groups/BackupOperators)
- [DnsAdmins](https://daniel10barredo.github.io/PrivEscAssist_Windows/#groups/DnsAdmins)
- [Exchange Windows Permissions](https://daniel10barredo.github.io/PrivEscAssist_Windows/#groups/ExchangeWindowsPermissions)
- [Hyper-V Administrators](https://daniel10barredo.github.io/PrivEscAssist_Windows/#groups/HyperVAdministrators)
- [Organization Management](https://daniel10barredo.github.io/PrivEscAssist_Windows/#groups/OrganizationManagement)
- [Print Operators](https://daniel10barredo.github.io/PrivEscAssist_Windows/#groups/PrintOperators)
- [Account Operators](https://daniel10barredo.github.io/PrivEscAssist_Windows/#groups/AccountOperators)
- [Server Operators](https://daniel10barredo.github.io/PrivEscAssist_Windows/#groups/ServerOperators)
