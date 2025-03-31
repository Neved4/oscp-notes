# Wi-Fi Credentials

This section covers the process of checking stored Wi-Fi network passwords on the system. While it is uncommon to reuse these passwords, they are still valuable to an attacker.

## Wi-Fi Networks

Commands for extracting stored Wi-Fi credentials from the system.

```batch
netsh wlan show profiles | findstr ":" | ForEach-Object { netsh wlan show profiles key=clear name= $_.split(":")[1].trim() }
```

```batch
:: To list saved networks
netsh wlan show profiles

:: To view the key for each network
netsh wlan show profiles key=clear name=[Wi-Fi_Name]
```
