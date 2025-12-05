#!/bin/bash
# Got root?
if [[ $EUID -ne 0 ]]; then
    echo "Execute this script as root. Maybe try sudo?"
    exit 2
fi

# Check for iface name parameter
if [ "$#" -eq 0 ]; then
    echo "Error: No username provided."
    echo "Usage: \$ $0 username"
    exit 2
fi

echo ""
echo "Creating user and /home directory..."
useradd -m -G wheel $1

echo ""
echo "Granting sudo privs..."
echo "$1 ALL=(root) NOPASSWD:ALL" >/etc/sudoers.d/${1}

echo ""
echo "Don't forget to set a password."
echo "All done."
echo ""
