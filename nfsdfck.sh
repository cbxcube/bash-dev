#!/usr/bin/env bash
#
# This script will check utilisation of NFS mounted filesystems
# Cubic 2020

# Banner
banner() {
	echo "=============================================================================================="
}

# Print header
clear
echo ""
banner

# Verification: uid
if [ "`id -u`" -eq 0 ]; then
  	echo "	OK: Running as Superuser."
else
  	echo "	ERROR: Need to run as root! Exiting..."
	banner
  	exit 1
fi


# "Verification: If yes=nfsmounts available 
if  df|grep ":" > /dev/null; then
	echo "	OK: NFS mount(s) detected." 
	isnfs=yes
else
	echo "	ERROR: No NFS mount(s) detected. Exiting..."
	banner
	isnfs=no
	exit 1
fi

# get list of nfs mounted filesystems
nfsfslist=$(mount |grep nfs  |awk '{print$3}')

# run df list
rundfcheck=$(for i in echo $nfsfslist; do df -h |grep $i; done)


banner
echo "List of NFS mount(s) on $(hostname)"
banner
echo "$rundfcheck"
banner

exit 0
