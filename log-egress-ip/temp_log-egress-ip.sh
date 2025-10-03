#!/bin/bash
# log-egress-ip.sh
# script that logs the timestamp and current network egress IP
# v0.2, by 0xSheepdog
# useage:
# - script meant to run out of /etc/cron.daily as 'root' but is user-executable
# - used with logrotate conf file /etc/logrotate.d/log-egress-ip.conf

# Got root? (scripted sudo edition)
sudo -v &>/dev/null
if [ $? -ne 0 ]; then
    # Test for interactive prompt ... run-by-user or run-by-cron?
    if [[ -z "$PS1" ]]; then
        logger local0.warning "cron.daily/log-egress-ip.sh failed 'Got root?' function"
    else
        echo "Error: 'sudo -v' command failed. Must allow sudo to root."
    fi
        exit 1
fi

# --- Configuration ---
LOG_FILE=/var/log/egress-ip.log
TIMESTAMP=$(TZ='Etc/UTC' date +%F_%T%Z)
EXTERNAL_IP=$(curl -s https://ipv4.icanhazip.com/)

# Check if the log file exists, create if absent
if [ ! -f "$LOG_FILE" ]; then
  sudo touch "$LOG_FILE"
  sudo chmod 0640 "$LOG_FILE"
  sudo echo "# Egress IP log file for $(hostname), created $TIMESTAMP" >> "$LOG_FILE"
fi

# --- Log the current timestamp and IP address to the file ---
sudo echo "$TIMESTAMP $EXTERNAL_IP" >> "$LOG_FILE"
