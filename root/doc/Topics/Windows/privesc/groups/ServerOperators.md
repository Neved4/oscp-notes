# Server Operators

Members of the **Server Operators** group can manage domain controllers and perform the following actions: log in interactively to a server, create and delete network shares, start and stop services, back up and restore files, format the computer's hard drive, and shut it down. [Learn More](https://learn.microsoft.com/en-us/windows-server/identity/ad-ds/manage/understand-security-groups#server-operators)

### Attack

Initially, we should check if we have any default privileges such as **SeBackupPrivilege** and **SeRestorePrivilege**, as indicated in the **privilege enumeration** phase. If these privileges do not appear, it is necessary to elevate to a high integrity level, for which one of the techniques suggested in the **UAC bypass techniques** section must be used.

[↪ UAC Bypass Techniques](https://daniel10barredo.github.io/PrivEscAssist_Windows/#info/UAC)

Once we have the privileges (enabled or not), there are several possibilities for escalation with this group. For example, they have the dangerous permissions of **SeBackupPrivilege** and **SeRestorePrivilege**.

[↪ SeBackupPrivilege](https://daniel10barredo.github.io/PrivEscAssist_Windows/#users/SeBackupPrivilege) [↪ SeRestorePrivilege](https://daniel10barredo.github.io/PrivEscAssist_Windows/#users/SeRestorePrivilege)
