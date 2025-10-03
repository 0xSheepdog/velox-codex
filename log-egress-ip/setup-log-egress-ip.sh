#!/bin/bash
# setup-log-egress-ip.sh
# script that downloads a script and logrotate conf file and sets file perms
# this script is written to run by `curl -s $URL| bash` but you may also run
# it manually
# v0.1, by sgss-jeff
# useage:
#  set -o pipefail && curl -sL | https://gitlab.sgssnrl.network/Jeff.Pettorino/velox-codex/-/raw/main/log-egress-ip/setup-log-egress-ip.sh?ref_type=heads&inline=true | bash

# Got root? (sudo edition)
sudo -v &>/dev/null

if [ $? -ne 0 ]; then
    echo "Error: 'sudo -v' command failed. Must allow sudo to root."
    exit 1
fi

# --- Configuration ---
CRON_OUT="/etc/cron.daily/log-egress-ip.sh"
CRON_URL="https://gitlab.sgssnrl.network/Jeff.Pettorino/velox-codex/-/raw/main/log-egress-ip/log-egress-ip.sh?ref_type=heads&inline=true"
LOGROTATE_OUT="/etc/logrotate.d/log-egress-ip.conf"
LOGROTATE_URL="https://gitlab.sgssnrl.network/Jeff.Pettorino/velox-codex/-/raw/main/log-egress-ip/log-egress-ip.conf?ref_type=heads&inline=true"

# --- Download cron-script ---
sudo curl -sL -o $CRON_OUT ${CRON_URL}
sudo chmod 0744 ${CRON_OUT}

# --- Download logrotate-conf ---
sudo curl -sL -o $LOGROTATE_OUT ${LOGROTATE_URL}
sudo chmod 0744 ${LOGROTATE_OUT}
