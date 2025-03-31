# Debug Privilege

This policy allows a user to attach to or open any process, including those they do not own. It is intended for developers debugging system components, but if leveraged by an attacker, it can grant access to sensitive and critical components. [Link](https://learn.microsoft.com/en-us/windows/security/threat-protection/security-policy-settings/debug-programs)

## Attack

Since any process memory can be read and written, various memory injection techniques can be used for privilege escalation while bypassing most antivirus solutions. A common example is using **[[mimikatz]]** to dump the **Local Security Authority Subsystem Service (LSASS)** process, which handles authentication and stores credentials of logged-in users. Another approach involves DLL injection into a SYSTEM-level process using `Invoke-DllInjection.ps1`. [Link](https://www.powershellgallery.com/packages/PowerSploit/3.0.0.0/Content/CodeExecution%5CInvoke-DllInjection.ps1)

## Tools

[Invoke-DllInjection.ps1](https://daniel10barredo.github.io/PrivEscAssist_Windows/tools/Invoke-DllInjection.ps1)
