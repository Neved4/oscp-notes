# Impersonate Privilege

This policy, typically assigned to service accounts, allows impersonation of a specific user or account, enabling actions on their behalf. Specifically, it defines which user accounts can call `CreateProcessAsUser()` in the Windows API, allowing a service to start another process. [Link](https://learn.microsoft.com/en-us/windows/security/threat-protection/security-policy-settings/impersonate-a-client-after-authentication)

## Attack

Privilege escalation exploits leveraging this policy include Juicy Potato and its variants. These attacks combine NBNS spoofing with internal NTLM relay to create a service executing a user-defined command with elevated credentials. Microsoft has attempted to mitigate these attacks, but some variations remain effective.

![[CLSIDs]]

## Tools

- [JuicyPotato.exe](https://daniel10barredo.github.io/PrivEscAssist_Windows/tools/JuicyPotato.exe)  
- [JuicyPotato32.exe](https://daniel10barredo.github.io/PrivEscAssist_Windows/tools/JuicyPotato32.exe)  
- [RoguePotato.exe](https://daniel10barredo.github.io/PrivEscAssist_Windows/tools/RoguePotato.exe)  
- [PrintSpoofer64.exe](https://daniel10barredo.github.io/PrivEscAssist_Windows/tools/PrintSpoofer64.exe)  
- [PrintSpoofer32.exe](https://daniel10barredo.github.io/PrivEscAssist_Windows/tools/PrintSpoofer32.exe)  

## Example

Verify that **SeImpersonatePrivilege** is available:

![Check Privilege](https://daniel10barredo.github.io/PrivEscAssist_Windows/media/imag/users/seImpersonate_1.png)

Since a **Potato** attack is required, check the target system with **systeminfo**:

![Check System Info](https://daniel10barredo.github.io/PrivEscAssist_Windows/media/imag/users/seImpersonate_2.png)

For **Windows 7 SP1**, execute **Juicy Potato** with a preconfigured reverse shell:

![Execute Juicy Potato](https://daniel10barredo.github.io/PrivEscAssist_Windows/media/imag/users/seImpersonate_3.png)

A SYSTEM-level reverse shell is obtained instantly:

![SYSTEM Shell](https://daniel10barredo.github.io/PrivEscAssist_Windows/media/imag/users/seImpersonate_4.png)
