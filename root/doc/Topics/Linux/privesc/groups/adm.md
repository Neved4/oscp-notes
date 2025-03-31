## Adm Group

The **adm** group is a group of administrators with special privileges related to system event logging and application log monitoring.

## Attack

In this case, there is no direct method for privilege escalation with this group; however, an attacker could read all files within the **`/var/log/`** directory and potentially access sensitive information, such as credentials, by reviewing application output logs.

```bash
# Some variations of log searches
aureport --tty | grep -E "su |sudo " | sed -E "s,su|sudo,${C}[1;31m&${C}[0m,g"
grep -RE 'comm="su"|comm="sudo"' /var/log* 2>/dev/null
```
