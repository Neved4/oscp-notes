_Crontabs_ are files that contain instructions for running tasks at specific times or on a recurring basis. This capability makes them a valuable target for attackers seeking potential pathways for privilege escalation or lateral movement within the system.

## Verification

### Crontab Files

First, we need to check all scheduled task files that we have read access to. To do this, we should examine the `/etc/crontab` file to see the scheduled tasks within it with the following command:

```bash
cat /etc/crontab 2>/dev/null
```

Next, verify if we have read access to the scheduled task files created by different users:

```bash
find /etc/cron* /etc/at* -type f -not -name "*.placeholder" -exec bash -c "echo;echo;echo ---------------------------------;echo {};echo ---------------------------------;cat {}" \;
```

As a last resort, (if we have sufficient permissions) we can try to read from the **syslog** to look for records of scheduled tasks and check for potential executions:

```bash
grep "CRON" /var/log/syslog 2>/dev/null | tail -n 50
```

### Monitoring Executions

Another way to attempt seeing scheduled tasks is to listen for new executions that are being performed regularly on the system. A useful tool for this task is **`pspy`**, a tool for process monitoring on Linux systems that allows you to view activities of processes running on the system.

## Attack

If we find any scheduled tasks, we should pay attention to the user executing them and the frequency at which they run (it is important to understand the syntax of these files). Once we know which command is being executed, we should investigate the following potential vectors for privilege escalation:

- **Check the binary's permissions:** verify if the binary or the folder containing it has weak permissions and if we can manipulate it to perform privilege escalation by simply changing the binary.
- **File code:** if the file being executed is a script, it's crucial to review the code to understand what it does and look for potential exploitation vectors such as executions, parameters, or libraries used that could allow us to gain execution.
- **PATH in crontab:** Check the `PATH` set in the crontab itself and verify if the user has permissions to manipulate any of the directories listed, studying the possibility of a hijacking attack.
- **Wildcard Injection:** Check if a command is being executed that uses a `*`, as we could create files with parameter names and inject execution (e.g., with `tar`).
- **Symbolic Links:** Check if the task being executed accesses a directory under our control. Sometimes, symbolic links can be created in such a way that we can redirect the execution path.
