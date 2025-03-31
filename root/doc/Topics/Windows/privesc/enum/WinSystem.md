# System Information

Collection of the most relevant system information.

```batch
systeminfo
```

## Storage Devices

Enumeration of connected storage devices.

```batch
wmic logicaldisk get caption,description,providername
```

```powershell
Get-PSDrive | where {$_.Provider -like "Microsoft.PowerShell.Core\FileSystem"} | ft Name,Root
```

## Environment Variables

Enumeration of environment variables. These may sometimes contain valuable system information or even credentials.

```batch
set
```

```powershell
Get-ChildItem env: | Format-Table -Wrap
```

## Drivers

Enumeration of installed drivers on the machine.

```batch
driverquery.exe /v /fo csv | ConvertFrom-CSV | Select-Object 'Display Name', 'Start Mode', 'Path'
```

```batch
driverquery /SI
```
