qua (quick user add)
====================

run the script (as root or with 'sudo', duh) with the name of the user you wish to add

1. creates user and home directory, with additional group membership in (wheel)
2. creates /etc/sudoers.d/<user> with sudo "NOPASSWD" priv's
3. expires the password setting with `chage -d 0`
