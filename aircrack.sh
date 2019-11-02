#!/bin/bash
# cubic (c) : operates aircrack, airmon, airodump in kali linux
# system commands
airdev="/usr/sbin/airmon-ng"
aircrack="/usr/bin/aircrack-ng"

# identify user and check if sudo is required for command
getid=$(whoami)
if [ $getid -eq "root" ]; then
  user = "root"
else
  user = "noroot"
fi
echo "Working as $user...\n"

# print gathered info
printf "Available wlan interfaces:\n"
if [ $user -eq "root" ]; then
  cmd=$(sudo '$airdev')
else
  cmd=$('$airdev')
fi
 
printf "$cmd\n"
