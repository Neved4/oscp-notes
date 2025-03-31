# Vulnerable Drivers

Another aspect to consider are the installed drivers on the system. Drivers sometimes contain vulnerabilities that can be exploited to escalate privileges. Since drivers operate with high privileges, an attacker who exploits one of these vulnerabilities can gain control of the system.

### Verification

To verify, we could use [**CheckWindDrivers**](https://github.com/Daniel10Barredo/checkWinDrivers). This script first hashes all drivers and then checks them locally against the [**LOLDrivers.io** database](https://www.loldrivers.io/).

Start by listing all drivers and generating MD5 hashes for each one with the following command:

```batch
driverquery.exe /v /fo csv | ConvertFrom-CSV | Select-Object 'Path' | ForEach-Object {$out=$_.Path+";";$out+=$(certUtil -hashFile $_.Path MD5)[1] -replace " ","";$out}
```

Next, copy and paste the output into a file and provide it as a parameter to the script:

```bash
python3 checkWinDrivers.py drivers.log
```

### Tools

- [CheckWindDrivers](https://github.com/Daniel10Barredo/checkWinDrivers)
