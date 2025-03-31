# Kernel Exploits

The sixth step in the methodology involves identifying potential vulnerabilities within the operating system, specifically focusing on known kernel vulnerabilities. An attacker could list the patches installed on the system to check if any critical updates are missing.

## Verification

A common method used by attackers to perform this task is through the tool [Windows Exploit Suggester](https://github.com/AonCyberLabs/Windows-Exploit-Suggester). This tool utilizes the output of the **`systeminfo`** command, which is available on all Windows systems. The command provides system information, including all installed patches, and compares it against a database of known vulnerabilities published by Microsoft.

Use the following command to gather system information and save it to a file on your attacking machine:

```bash
systeminfo
```

To use Windows Exploit Suggester:

```bash
./wes.py -e [systeminfo_file]
```

If the tool identifies any missing critical security patches, it will provide a summary of the vulnerability, including its ID and reference links to further details. This enables the attacker to search for an exploit for the identified vulnerability to potentially escalate privileges on the system.

## Example

Start by executing the `systeminfo` command on the target machine to gather information about installed patches and the operating system version.

![](https://daniel10barredo.github.io/PrivEscAssist_Windows/media/imag/os/Kernel_1.png)

Copy the output to a file on your attacking machine, named `systeminfo.txt`, for analysis by the **Windows Exploit Suggester** tool. Before proceeding with the analysis, remember to download the update database using the `--update` parameter. This generates an `.xls` file in the same directory, which should then be passed to the analysis command.

![](https://daniel10barredo.github.io/PrivEscAssist_Windows/media/imag/os/Kernel_2.png)

In this case, we can see that the system is vulnerable to **MS16-135**, which affects kernel drivers and allows privilege escalation. It's important to note that the letter **[E]** indicates an exploit exists for this vulnerability, whereas **[M]** would indicate a Metasploit module has been implemented.

Next, we use the FuzzySec script `MS16-135.ps1` to escalate privileges to SYSTEM, as demonstrated below.

![](https://daniel10barredo.github.io/PrivEscAssist_Windows/media/imag/os/Kernel_3.png)

This is just one example of what may be encountered in this section. The exploitation process must be adapted to the specific vulnerability discovered and the available exploits.
