# Assign Primary Token Privilege

This policy is typically assigned to service accounts and allows the replacement of the access token associated with a secondary process. Specifically, it grants user accounts the ability to call **`CreateProcessAsUser()`** from the Windows API, enabling a service to initiate another process.

A token contains the identity and privileges of the account associated with the process. With this privilege, all secondary processes can have their access token replaced by the process-level token. [Link.](https://learn.microsoft.com/en-us/windows/security/threat-protection/security-policy-settings/replace-a-process-level-token)

### Attack

Exploitation of this privilege is well-known in the community, with Juicy Potato and its variants being some of the most common attack techniques. These attacks rely on a combination of **NBNS spoofing** and **NTLM relay** to internally create a service with credentials that run a user-defined command.

While Microsoft has made efforts to block these attacks, some variants remain functional for compatibility reasons. The [**Juicy Potato**](https://github.com/ohpe/juicy-potato) exploit works up to Windows 10 build 1809 and Windows Server 2019. For later versions, another variant like [**Rouge Potato**](https://github.com/antonioCoco/RoguePotato) should be used.

![[CLSIDs]]

### Tools

- [JuicyPotato.exe](https://daniel10barredo.github.io/PrivEscAssist_Windows/tools/JuicyPotato.exe)
- [JuicyPotato32.exe](https://daniel10barredo.github.io/PrivEscAssist_Windows/tools/JuicyPotato32.exe)
- [RoguePotato.exe](https://daniel10barredo.github.io/PrivEscAssist_Windows/tools/RoguePotato.exe)
- [PrintSpoofer64.exe](https://daniel10barredo.github.io/PrivEscAssist_Windows/tools/PrintSpoofer64.exe)
- [PrintSpoofer32.exe](https://daniel10barredo.github.io/PrivEscAssist_Windows/tools/PrintSpoofer32.exe)

## Example

First, we check the privileges the process has.

![](https://daniel10barredo.github.io/PrivEscAssist_Windows/media/imag/users/assignPrim_1.png)

As shown, the **AssignPrimaryToken** privilege is assigned to the user. Since this is a Windows 7 system, we will use **Juicy Potato** to execute a reverse shell hosted on the attacking machine.

![](https://daniel10barredo.github.io/PrivEscAssist_Windows/media/imag/users/assignPrim_2.png)

As seen in the next capture, we immediately obtain a connection with SYSTEM privileges.

![](https://daniel10barredo.github.io/PrivEscAssist_Windows/media/imag/users/assignPrim_3.png)
