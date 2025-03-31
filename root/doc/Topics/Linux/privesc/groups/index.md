# User & Groups

The second step of the methodology involves reviewing the groups the current user belongs to. This is essential, as certain groups may have default special permissions that could allow an attacker to escalate privileges on the system.

## Check

Use the following command to check the groups the user belongs to.

```bash
id
```

The groups with privileges that an attacker could exploit for privilege escalation are as follows:
- [[root]]
- [[wheel]]
- [[shadow]]
- [[staff]]
- [[disk]]
- [[video]]
- [[docker]]
- [[lxc]]
- [[adm]]
