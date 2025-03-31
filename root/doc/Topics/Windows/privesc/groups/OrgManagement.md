# Organization Management

During the installation of Microsoft Exchange, several security groups related to Exchange are created in Active Directory. The **Organization Management** group has access to all activities related to Microsoft Exchange, including modifying user membership in other Exchange groups. [Learn More](https://learn.microsoft.com/en-us/exchange/organization-management-exchange-2013-help)

### Attack

An attacker could add their user to the **Windows Exchange Permissions** group, as seen previously, and then proceed with the known privilege escalation.

Add a user to the 'Exchange Windows Permissions' group:

```batch
net group "Exchange Windows Permissions" [user] /add
```

And continue with the exploitation of the **Exchange Windows Permissions** group.

[↪ Exchange Windows Permissions](https://daniel10barredo.github.io/PrivEscAssist_Windows/#groups/ExchangeWindowsPermissions)
