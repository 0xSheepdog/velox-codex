# README-log-egress-ip

## Overview
this function queries a website that replies with the IP that requested the page
then writes this value to a log-file.

it includes a logrotate conf file to manage the log-file.

the repo consists of a setup-script, the cron-daily script and the logrotate.d
conf file.

the setup-script is designed to run from a `curl | bash` command so the operator
does not need to download anything. however, it can be downloaded used locally
if desired.

### The cron-daily script
the script is `/etc/cron.daily/log-egress-ip.sh`

### Ths logrotate.d configuration
the logrotate conf is `/etc/logrotate.d/log-egress-ip.conf`

### Other things
the setup-script is written to execute from a single command in the terminal,
but it depends on sudo privileges for `root`.

to execute the script from a single command, copy-pasta this:
```
set -o pipefail && curl -sL "https://ADDRess/setup-log-egress-ip.sh?ref_type=heads&inline=true" | bash
```
