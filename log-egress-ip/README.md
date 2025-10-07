# README-log-egress-ip

## Overview
this function queries a website that replies with the IP that requested the page
then writes this value to a log-file.

the repo consists of a setup-script and the cron-daily script.

the setup-script is designed to run from a `curl | bash` command so the operator
does not need to download anything. however, it can be downloaded used locally
if desired.

### The cron-daily script
the script is `/etc/cron.daily/log-egress-ip.sh`

### Other things
the setup-script is written to execute from a single command in the terminal,
but it depends on sudo privileges for `root`.

to execute the script from a single command, copy-pasta this:
```
set -o pipefail && curl -sL "https://github.com/0xSheepdog/velox-codex/blob/7ac47638d770a9d2be3ea1aaea0a5625be334d32/log-egress-ip/setup-log-egress-ip.sh" | bash
```
