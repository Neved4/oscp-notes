# Installed Programs on the System

## Installed Programs

Enumerate installed programs on the system.

```batch
dir /a "C:\Program Files", "C:\Program Files (x86)"
reg query HKEY_LOCAL_MACHINE\SOFTWARE
```

```powershell
Get-ChildItem 'C:\Program Files', 'C:\Program Files (x86)' | ft Parent,Name,LastWriteTime
Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\*" | select displayname
Get-ItemProperty "HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*" | select displayname
Get-ChildItem -path Registry::HKEY_LOCAL_MACHINE\SOFTWARE | ft Name
Get-CimInstance -class win32_Product | Select-Object Name, Version
```

## Processes

Enumerate running processes and applications on the system.

```batch
tasklist /svc
```

```powershell
Get-Process | where {$_.ProcessName -notlike "svchost*"} | ft ProcessName, Id

# With username
Get-WmiObject -Query "Select * from Win32_Process" | where {$_.Name -notlike "svchost*"} | Select Name, Handle, @{Label="Owner";Expression={$_.GetOwner().User}} | ft -AutoSize
```

## Windows Subsystem for Linux

Check if the Windows Subsystem for Linux (WSL) is installed.

```batch
:: Generally, this will be present by default
dir C:\Windows\System32\wsl.exe

:: This file exists only when WSL is installed
dir C:\Windows\System32\bash.exe

:: To check the list of installed distributions
wslconfig /list
```

If installed, the list of distributions can be viewed.

```batch
wslconfig /list
```
