# Autologon Credentials

Windows allows automatic user logon without requiring credential input at startup. These credentials are stored in the registry.

### Verification

To check for the presence of Autologon credentials in the registry, use one of the following commands in PowerShell or CMD:

```powershell
Get-ItemProperty -Path 'Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\WinLogon' | select "Default*"
```

```batch
reg query "HKLM\SOFTWARE\Microsoft\Windows NT\Currentversion\Winlogon" 2>nul | findstr "DefaultUserName DefaultDomainName DefaultPassword"
```
