#!/usr/bin/env bash

# provide 2 argumetns and script will compare if there is difference in content

dir01="$1"
dir02="$2"
tmpfile1="/tmp/dir01.txt"
tmpfile2="/tmp/dir02.txt"
hashfile1="/tmp/hash1.txt"
hashfile2="/tmp/hash2.txt"


# Argument required
if [ $# -gt 0 ] 
  then 
	dir01="$1"
	dir02="$2"

	printf "\n\n"
	printf "###    Starting to verify if content of directories below is identical:\n" 
        printf "Directory 01: $dir01\n"
        printf "Directory 02: $dir02\n"
  else
        printf "Arguments were  not provided. Supply 2 direcories to compare as the script arguments. Exiting!\n"
        exit 1
fi

search1() {
	#find $dir01 2>/dev/null
	sudo find $dir01  1>$tmpfile1 2>/dev/null 
	cat $tmpfile1
}

search2() {
	#find $dir02 2>/dev/null
	sudo find $dir02 
}


# Printing files from directories:
printf "\n\n"
printf "###    Content of files and directories found in: $dir01\n" 
search1
printf "\n\n"
printf "###    Content of files and directories found in: $dir02\n" 
search2
printf "\n\n"

# Checksum of files
chsm1() {
	touch $hashfile1
	for line in $(cat $tmpfile1 ); do
		$(sudo md5sum $line 2>/dev/null) >> $hashfile1;
	done
}

chsm1
printf "\n\n"

# Printing hashes of all files in directories:
printf "\n\n"
printf "###    Hash of all files found in: $dir01\n"
cat $hashfile1
printf "\n\n"




### EVALUATE DIFFERENCES: 
# DIFF 2 files




# Wiping tmp files
sudo rm $tmpfile1 $tmpfile2 $hashfile1 $hashfile2

exit 0
