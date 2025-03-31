# Registry Credentials

Credentials for various applications may sometimes be found stored in the registry.

## Known Registry Locations

Run the following commands to check if any credentials are stored in these known registry locations:

```powershell
@("HKLM:\SYSTEM\Current\ControlSet\Services\SNMP","HKCU:\Software\SimonTatham\PuTTY\Sessions","HKCU:\Software\SimonTatham\PuTTY\SshHostKeys\","HKCU:\Software\ORL\WinVNC3\Password","HKLM:\SOFTWARE\RealVNC\WinVNC4","HKCU:\Software\Microsoft\Terminal Server Client\Servers","HKCU:\Software\TightVNC\Server","HKCU:\Software\OpenSSH\Agent\Key") | ForEach-Object {if(Test-Path $_){Get-ItemProperty $_}}
```

```batch
:: SNMP parameters
reg query "HKLM\SYSTEM\Current\ControlSet\Services\SNMP"

:: Putty proxy credentials
reg query "HKCU\Software\SimonTatham\PuTTY\Sessions"

:: Putty known SSH hosts
reg query "HKCU\Software\SimonTatham\PuTTY\SshHostKeys\"

:: VNC credentials
reg query "HKCU\Software\ORL\WinVNC3\Password"

:: RealVNC credentials
reg query "HKLM\SOFTWARE\RealVNC\WinVNC4" /v password

:: RDP credentials
reg query "HKCU\Software\Microsoft\Terminal Server Client\Servers"

:: TightVNC credentials
reg query "HKCU\Software\TightVNC\Server"

:: OpenSSH agent keys
reg query "HKCU\Software\OpenSSH\Agent\Key"
```

## Searching the Registry

It is also advisable to perform a recursive search across all registry keys for potential credentials, both in user-accessible and local machine areas.

```batch
:: Search registry on local machine
reg query HKLM /F "passw" /t REG_SZ /S /K
reg query HKLM /F "passw" /t REG_SZ /S /d

:: Search user registry
reg query HKCU /F "passw" /t REG_SZ /S /K
reg query HKCU /F "passw" /t REG_SZ /S /d
```
