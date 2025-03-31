# Load Driver Privilege

This policy determines which users can dynamically load and unload device drivers, which execute with elevated privileges. Typically, printer operator groups have this privilege. However, drivers must be signed to be installed. [Link](https://learn.microsoft.com/en-us/windows/security/threat-protection/security-policy-settings/load-and-unload-device-drivers)

## Attack

Attackers, constrained by Windows driver signing enforcement, can exploit known vulnerable drivers such as `Capcom.sys` [Link](https://github.com/FuzzySecurity/Capcom-Rootkit/blob/master/Driver/Capcom.sys), which allows arbitrary code execution while retaining a valid Windows signature.

To load the driver, `EopLoadDriver` [Link](https://github.com/TarlogicSecurity/EoPLoadDriver) can be used. Once loaded, executing the relevant exploit ([ExploitCapcom](https://github.com/tandasat/ExploitCapcom)) grants SYSTEM-level code execution.

## Tools

- [Capcom.sys](https://daniel10barredo.github.io/PrivEscAssist_Windows/tools/Capcom.sys)  
- [EopLoadDriver.exe](https://daniel10barredo.github.io/PrivEscAssist_Windows/tools/EopLoadDriver.exe)  
- [ExploitCapcom.exe](https://daniel10barredo.github.io/PrivEscAssist_Windows/tools/ExploitCapcom.exe)  
