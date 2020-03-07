#!/usr/bin/env bash
#
# This script will check utilisation of NFS mounted filesystems
# Cubic 2020


# Verification: check if ":" in column 1. If yes=nfsmounts available 
if [ df |grep :]; then
	print "NFS mount points detected." 
	isnfs=yes
else
	print "No NFS mount points detected. Exiting..."	
	isnfs=no
	exit 1
fi

# get list of nfs mounted filesystems
nfsfslist=$(mount |grep nfs  |awk '{print$3}')

# run df list
rundfcheck=$(for i in $nfsfslist; do df -h |grep $i; done)


print "========================================================="
print "List of NFS mountpoints on $hostname"
print "DEBUG: rundfcheck output"
rundfcheck


echo "========================================================="
echo "Checking if NFS mounts available..."
print "========================================================="
printf "nfslist variable:"
print "========================================================="
print $isnfs
print "========================================================="
