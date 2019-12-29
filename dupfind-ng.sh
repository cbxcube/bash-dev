#!/bin/bash

# find duplicates in folder which is provided as $1 to the script

clear 

printf "   Starting duplicate finder program by Cubic(c)2019.\n"

folder=$1

listfiles=/tmp/listfiles
listmd5cs=/tmp/listmd5cs
listdupnr=/tmp/listdupnr
listdupls=/tmp/listdupls


get_file_list() {
	#cd $folder
	find $folder -type f -print0 |xargs -0 -i echo "{}"|sort  > $listfiles
}

get_md5sum() {
	#for i in "$(cat $listfiles)"; do  md5sum "$i"; done > $listmd5cs
	cat $listfiles |while read line; do md5sum "$line"; done > $listmd5cs
}

get_dupnum() {
	cat $listmd5cs | awk '{print $1}' |uniq -c |grep -v ^......1 > $listdupnr
}

get_duplist() {
	for i in $(cat $listdupnr); do grep "$i" $listmd5cs >> $listdupls; done
}

get_duplsout() {
	printf "================================================================\n"
	printf "   List of identified duplicates in $folder\n"
	printf "================================================================\n"
	#for i in $(cat $listdupnr|awk '{print $2}'); do grep "$i" $listmd5cs; done |awk '{print $2}' > $listdupls
	#cat $listdupnr|awk '{print $2}'|while read line; do grep "$i" $listmd5cs; done |awk '{print $2}' > $listdupls
	awk '{print $2}' $listdupnr |while read line; do grep "$line" $listmd5cs; done |awk '{print $2}' > $listdupls
	for i in "$(cat $listdupls)"; do ls -lh "$i"; done;
}

cleanup() {
	rm $listfiles $listmd5cs $listdupnr $listdupls
}

# RUNTIME:

get_file_list
get_md5sum
get_dupnum
get_duplist
get_duplsout

printf "================================================================\n"
	
### Check if all files has been uniq. if yes exit, if no list duplicates.

if [ "$(wc -l < $listfiles)" -eq "$(wc -l < $listdupls)" ]; then
	printf "   No duplicates detected\n"
else
	printf "   Duplicate files has been found. Exiting the program.\n"
fi

# Clean temporary files
#cleanup

exit 0
