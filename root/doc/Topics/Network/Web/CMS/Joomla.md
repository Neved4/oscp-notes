# Prerequisites

- [ ] Install `joomscan` with `apt install joomscan`

# Enumeration

- [ ] Run `joomscan` check

  ```bash
  perl joomscan.pl -u http::/localhost:8080/
  ```

- [ ] Start a server to check the reports
  ```bash
  cd reports/localhost:8080
  mv <report.html> index.htmlp
  python3 -m http.server 80
  ```
