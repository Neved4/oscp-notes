# Backup Operators

Members of the **Backup Operators** group have the ability to back up and restore files on a system, regardless of the permissions that protect those files.

This group is by default assigned two interesting privileges for privilege escalation, as explained in the previous section: **SeBackupPrivilege** and **SeRestorePrivilege**, which allow copying sensitive files or restoring files to protected locations. [Learn More](https://learn.microsoft.com/en-us/windows-server/identity/ad-ds/manage/understand-security-groups#backup-operators)

### Attack

Initially, we should verify whether the default privileges, **SeBackupPrivilege** and **SeRestorePrivilege**, are enabled, as indicated in the **Privilege Enumeration** phase. If these privileges do not appear, it is necessary to elevate to a higher integrity level. In this case, use one of the techniques suggested in the **UAC Bypass Techniques** section.

[↪ UAC Bypass Techniques](https://daniel10barredo.github.io/PrivEscAssist_Windows/#info/UAC)

**Once the permissions** (enabled or not) are confirmed, we have two options: Perform a **SAM and SYSTEM dump** as suggested in **SeBackupPrivilege**, or attempt to replace a service binary and seek execution as SYSTEM, as suggested in **SeRestorePrivilege**.

[↪ SeBackupPrivilege](https://daniel10barredo.github.io/PrivEscAssist_Windows/#users/SeBackupPrivilege) [↪ SeRestorePrivilege](https://daniel10barredo.github.io/PrivEscAssist_Windows/#users/SeRestorePrivilege)
