# README-log-egress-ip

## Overview
this function queries a website that replies with the plaintext value of the IP
that requested the page, then writes this value with the timestamp into a
log-file.

it includes a logrotate conf file to manage the log-file size, although the size
of the log-file should never be an issue, given the data is a very small plain
text string written once a day. nevertheless the logrotate will attempt to
ensure the log-file doesn't run away and eat up the filesystem.

the function consists of a setup-script, the cron-daily script and the
logrotate.d conf file.

the setup-script downloads the other two files and sets permissions for them to
run as system functions, once from cron and one under logrotate (obviously).

the setup-script is designed to run from a `curl | bash` command so the operator
does not need to download anything, they only need to copy the location URL to
the setup-script and paste it into an appropriate terminal command prompt.

however, the setup-script and files can be downloaded and manipulated manually
if desired.

### The cron-daily script
the script is downloaded to `/etc/cron.daily/log-egress-ip.sh` which performs a
few simple commands. it checks that it can use `sudo`, it looks for the log-file
and creates it if missing, and then it runs a command to `curl` a website that
replies with the plaintext value of the IP that requested the page. it then
writes that value with the timestamp into the log-file.

### Ths logrotate.d configuration
the logrotate conf is downloaded to `/etc/logrotate.d/log-egress-ip.conf` which
informs the logrotate system function to manage the log-file per the settings
provided.

### Other things
the setup-script is written to execute from a single command in the terminal,
but it depends on sudo privileges for `root`.

to execute the script from a single command, copy-pasta this:
```
set -o pipefail && curl -sL "https://gitlab.sgssnrl.network/Jeff.Pettorino/velox-codex/-/raw/main/log-egress-ip/setup-log-egress-ip.sh?ref_type=heads&inline=true" | bash
```

the operator may also download the setup script and review, modify, and execute
it locally as they see fit.
