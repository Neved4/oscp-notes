# Startup

The sixth point of the methodology involves searching for potential vulnerabilities in applications that are executed automatically when a certain condition is met on the system. These tasks allow for administrative operations without user intervention but can also pose risks if not properly configured.

Startup applications are executed when a user logs in or when the system boots, and they are located in various known registry locations or common directories. These applications are a well-known resource for attackers for persistence purposes, but they can also be used for potential privilege escalation if not properly configured.

## Directory Permissions

This step involves listing all binary locations for each startup application and checking if the user can modify the binary or its directories.

> [!NOTE]
> Requires auxiliary function [[ModPathCheck]].

```powershell
Get-WmiObject Win32_StartupCommand |
    Where-Object { $_ -and $_.Command } |
    ForEach-Object {
        if (ModifiablePath $_.Command) { $_ }
    }

# Only to list tasks
Get-WmiObject Win32_StartupCommand |
    Select-Object Name, Command, Location, User | fl
```

It is also possible to manually check with CMD and icacls as follows.

```batch
wmic startup get caption,command

:: Checking each one
icacls "C:\path to command"
```

## Startup Directories

There are also special directories where binaries can be placed for execution at login. These directories are:

```batch
dir /b "C:\Documents and Settings\All Users\Start Menu\Programs\Startup" 2>nul
dir /b "C:\Documents and Settings\%username%\Start Menu\Programs\Startup" 2>nul
dir /b "%programdata%\Microsoft\Windows\Start Menu\Programs\Startup" 2>nul
dir /b "%appdata%\Microsoft\Windows\Start Menu\Programs\Startup" 2>nul
```

## Auto-Start Registry Entries

Numerous registry locations can contain applications for execution at login or during system startup. These are the following:

```powershell
@(
    "HKLM:\Software\Microsoft\Windows\CurrentVersion\Run",
    "HKLM:\Software\Microsoft\Windows\CurrentVersion\RunOnce",
    "HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Run",
    "HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\RunOnce",
    "HKCU:\Software\Microsoft\Windows\CurrentVersion\Run",
    "HKCU:\Software\Microsoft\Windows\CurrentVersion\RunOnce",
    "HKCU:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Run",
    "HKCU:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\RunOnce",
    "HKLM:\Software\Microsoft\Windows NT\CurrentVersion\Terminal Server\Install\Software\Microsoft\Windows\CurrentVersion\Run",
    "HKLM:\Software\Microsoft\Windows NT\CurrentVersion\Terminal Server\Install\Software\Microsoft\Windows\CurrentVersion\RunOnce",
    "HKLM:\Software\Microsoft\Windows NT\CurrentVersion\Terminal Server\Install\Software\Microsoft\Windows\CurrentVersion\RunE",
    "HKLM:\Software\Microsoft\Windows\RunOnceEx",
    "HKLM:\Software\Wow6432Node\Microsoft\Windows\RunOnceEx",
    "HKCU:\Software\Microsoft\Windows\RunOnceEx",
    "HKCU:\Software\Wow6432Node\Microsoft\Windows\RunOnceEx",
    "HKLM:\Software\Microsoft\Windows\CurrentVersion\RunServicesOnce",
    "HKCU:\Software\Microsoft\Windows\CurrentVersion\RunServicesOnce",
    "HKLM:\Software\Microsoft\Windows\CurrentVersion\RunServices",
    "HKCU:\Software\Microsoft\Windows\CurrentVersion\RunServices",
    "HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\RunServicesOnce",
    "HKCU:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\RunServicesOnce",
    "HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\RunServices",
    "HKCU:\Software\Wow5432Node\Microsoft\Windows\CurrentVersion\RunServices",
    "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon"
) | ForEach-Object {
    if (Test-Path $_) {
        echo ""
        echo $_
        echo ""
        Get-ItemProperty $_
    }
}
```

```batch
:: List of Startup registry entries
reg query HKLM\Software\Microsoft\Windows\CurrentVersion\Run
reg query HKLM\Software\Microsoft\Windows\CurrentVersion\RunOnce
reg query HKLM\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Run
reg query HKLM\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\RunOnce
reg query HKCU\Software\Microsoft\Windows\CurrentVersion\Run
reg query HKCU\Software\Microsoft\Windows\CurrentVersion\RunOnce
reg query HKCU\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Run
reg query HKCU\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\RunOnce
reg query HKLM\Software\Microsoft\Windows NT\CurrentVersion\Terminal Server\Install\Software\Microsoft\Windows\CurrentVersion\Run
reg query HKLM\Software\Microsoft\Windows NT\CurrentVersion\Terminal Server\Install\Software\Microsoft\Windows\CurrentVersion\RunOnce
reg query HKLM\Software\Microsoft\Windows NT\CurrentVersion\Terminal Server\Install\Software\Microsoft\Windows\CurrentVersion\RunE
reg query HKLM\Software\Microsoft\Windows\RunOnceEx
reg query HKLM\Software\Wow6432Node\Microsoft\Windows\RunOnceEx
reg query HKCU\Software\Microsoft\Windows\RunOnceEx
reg query HKCU\Software\Wow6432Node\Microsoft\Windows\RunOnceEx

reg query HKLM\Software\Microsoft\Windows\CurrentVersion\RunServicesOnce
reg query HKCU\Software\Microsoft\Windows\CurrentVersion\RunServicesOnce
reg query HKLM\Software\Microsoft\Windows\CurrentVersion\RunServices
reg query HKCU\Software\Microsoft\Windows\CurrentVersion\RunServices
reg query HKLM\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\RunServicesOnce
reg query HKCU\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\RunServicesOnce
reg query HKLM\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\RunServices
reg query HKCU\Software\Wow5432Node\Microsoft\Windows\CurrentVersion\RunServices

:: Executed at login Winlogon
reg query "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" /v "Userinit"
reg query "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" /v "Shell"
```

## Example

First, **load the auxiliary function** and run the suggested script, which will check all startup tasks and see if it is possible to manipulate the binary being executed.

![](https://daniel10barredo.github.io/PrivEscAssist_Windows/media/imag/autorun/autorun_1.png)

It appears that a program called **My Program** starts when the user logs in. Let's gather more information about this scheduled task.

![](https://daniel10barredo.github.io/PrivEscAssist_Windows/media/imag/autorun/autorun_2.png)

We then check that there is a vulnerability with **icacls**.

![](https://daniel10barredo.github.io/PrivEscAssist_Windows/media/imag/autorun/autorun_3.png)

As shown, everyone has full permissions on this binary. To perform the attack, we create a reverse shell and replace the binary.

![](https://daniel10barredo.github.io/PrivEscAssist_Windows/media/imag/autorun/autorun_4.png)

Now, we just need to wait for a user with elevated privileges to log in to gain their privileges.

![](https://daniel10barredo.github.io/PrivEscAssist_Windows/media/imag/autorun/autorun_5.png)
