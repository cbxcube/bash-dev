#!/usr/bin/env bash
#
# This script will check utilisation of NFS mounted filesystems
# Cubic 2020

# Print header
clear
echo ""
echo "=============================================================================================="

# Verification: check if ":" in column 1. If yes=nfsmounts available 
if  df|grep ":" > /dev/null; then
	echo "	NFS mount points detected." 
	isnfs=yes
else
	echo "No NFS mount points detected. Exiting..."	
	isnfs=no
	exit 1
fi

# get list of nfs mounted filesystems
nfsfslist=$(mount |grep nfs  |awk '{print$3}')

# run df list
rundfcheck=$(for i in echo $nfsfslist; do df -h |grep $i; done)


echo "=============================================================================================="
echo "	List of NFS mountpoints on $(hostname)"
echo ""
echo "$rundfcheck"

exit 0
