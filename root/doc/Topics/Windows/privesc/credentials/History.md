# Credential History

Certain commands allow credentials to be input in plaintext as parameters, and these commands are subsequently stored in command history, often without the user paying sufficient attention.

## PowerShell History

Command to search for credentials within PowerShell's history:

```powershell
# PowerShell history file
dir $env:APPDATA\Microsoft\Windows\PowerShell\PSReadLine\ConsoleHost_history.txt

# Search within using PowerShell
cat (Get-PSReadlineOption).HistorySavePath | Select-String passw
```

## Console History

Command to search for credentials within the console history:

```batch
:: CMD history file
dir $env:USERPROFILE\AppData\Roaming\Microsoft\Windows\PowerShell\PSReadline\ConsoleHost_history.txt

:: Search within file using cmd
cat $env:USERPROFILE\AppData\Roaming\Microsoft\Windows\PowerShell\PSReadline\ConsoleHost_history.txt | Select-String passw
```

## Recent Commands (Win+R)

Command to display the recent command history of the current user:

```powershell
foreach ($p in $property) {Write-Host "$((Get-Item "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\RunMRU"-ErrorAction SilentlyContinue).getValue($p))"}
```

## Others

PowerShell Transcript logging:

```batch
reg query HKCU:\Software\Policies\Microsoft\Windows\PowerShell\Transcription
reg query HKLM:\Software\Policies\Microsoft\Windows\PowerShell\Transcription
```

Event log for the term "password" (Administrator privileges required):

```powershell
Get-EventLog -LogName Security | Where-Object { $_.Message -like "*password*" } | Format-Table -Property Message -wrap
```
