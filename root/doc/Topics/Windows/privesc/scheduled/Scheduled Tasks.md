# Scheduled Tasks

The sixth step of the methodology involves searching for potential vulnerabilities in applications that are automatically executed when a specific condition is met on the system. These tasks allow for administrative operations without user intervention but can also pose risks if not properly configured.

Scheduled tasks are applications that run automatically on a specific date or are triggered by a particular event. The characteristics of each task are defined in an XML file located in **`%windir%\System32\Tasks`**, and are also referenced in the registry.

## Directory Permissions

This step involves listing all the binary locations for each scheduled task and checking if the user can modify the binary or its directories.

> [!NOTE]
> Requires the auxiliary function [[ModPathCheck]].

```powershell
Get-ScheduledTask -ErrorAction Ignore | where {$_.principal.RunLevel -eq "Highest"} | Where-Object {$Null -ne $_.Actions.Execute} | ForEach-Object { if(ModifiablePath $_.Actions.Execute){ $_ } }
# To list those running with elevated privileges
Get-ScheduledTask | where {$_.principal.RunLevel -eq "Highest"} | Where-Object {$Null -ne $_.Actions.Execute} | ft TaskName,TaskPath,State
```

It is also possible to manually check with CMD and `icacls` as follows:

```batch
:: Lists scheduled tasks
schtasks /query /fo LIST /v | findstr "Task\ To\ Run:" | findstr ".exe"

:: Check permissions for each task
icacls "C:\path to command"
```

## Process Monitoring

In some cases, the current user might not be able to list the scheduled tasks running with higher privileges. However, it may be possible to monitor the tasks running periodically on the system over time using the following code.

```powershell
while($true)
{
    $process = Get-WmiObject Win32_Process | Select-Object CommandLine
    Start-Sleep 1
    $process2 = Get-WmiObject Win32_Process | Select-Object CommandLine
    Compare-Object -ReferenceObject $process -DifferenceObject $process2
}
```
