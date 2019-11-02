#!/usr/bin/env bash

# This is job which runs every 2 minutes from root cron on kaliT400
# /home/cubic/Dropbox/scripts/bash/cronmon.sh is used to monitor this job


log_file="/var/tmp/cron_minute_test.log"

printf "$(date) -- Job completed OK.\n" >> "${log_file}"
#echo "${date}" >> "${logfile}"

exit 0
