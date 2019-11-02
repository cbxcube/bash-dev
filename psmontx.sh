#!/usr/bin/env bash
#

# This script will watch one PID and log it's activity in /tmp/$PID_ps.log
# Script will cycle for defined number of cycles.

# Argument required
if [ $# -gt 0 ] 
  then 
	pspid=$1
	printf "Process PID provided: $pspid\n"
  else
	printf "Argument was not provided. Supply PID to the script as argument. Exiting!\n"
	exit 1
fi


# vars
tmpfile="/tmp/pslist_"$pspid".log"
repeat_target=30

# create log life
touch $tmpfile

if [ $? == 0 ] 
  then
	printf "Log file $tmpfile created.\n"
  else
	printf "Log file for this PID already exists.\n"
        printf "Appending to $tmpfile cannot be created. Exiting!\n"
	exit 1
fi


# functions
log_header() {
	sudo top -b -n1 -p $pspid > $tmpfile
	sleep 1
}


topwatch() {
	repeat=0
	while [ $repeat -le $repeat_target ]
	do
		sudo top -b -n1 -p $pspid |tail -1 >> $tmpfile
		printf "Repeating for $repeat times.\n"
		((repeat++))
		sleep 1
	done
	
}


# execution
log_header
topwatch

printf "Finishing after $repeat_target logged entries for $pspid.\n"
exit 0
