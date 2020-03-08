#!/usr/bin/env bash
#
# This function will send all script output to the log file
# It's ideal for scripts which run as daemon 
#

# Log file:
logfile=/tmp/logall.log

# Log redirection
exec 3>&1 4>&2
trap 'exec 2>&4 1>&3' 0 1 2 3
exec 1>$logfile 2>&1
# Everything below will go to the file 'logfile':

# Script steps:
echo "starting script"
date
uptime
echo "end of the script"

exit 0
