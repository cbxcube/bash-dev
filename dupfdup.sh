#!/usr/bin/env bash
# find duplicates using fdupe binary

targetdir=$1

if [ $# -gt 0 ]; then
	echo "Starting to look for duplicates in directory: $targetdir - $(date)."
else
	echo "Target directory for duplicate search not provided. Exiting..."
	exit 1

fi

if [ -e /usr/bin/fdupes ]; then
	echo "Fdupes binary present."
else
	echo "Fdupes binary not found. Run "sudo apt install fdupes" to install it. Exiting..."
	exit 1

fi

search() {
	if [ -ne "$targetdir"/"$targetdir"_dupplicates-all.txt ]; then
		touch "$targetdir"/"$targetdir"_dupplicates-all.txt 
		ls -l "$targetdir"/"$targetdir"_dupplicates-all.txt 
		echo "Duplicates will be listed in file: "$targetdir"/"$targetdir"_dupplicates-all.txt"

	elseif 
		[ -e "$targetdir"/"$targetdir"_dupplicates-all.txt ]; then
		echo "Duplicates result file "$targetdir"/"$targetdir"_dupplicates-all.txt already exist."
		echo "Creating Result file in ~/"$targetdir"_dupplicates-all.txt"
	else
		echo "Failed to create the file: "$targetdir"/"$targetdir"_dupplicates-all.txt" 
		exit 1
	fi


	fdupes -r $targetdir > "$targetdir/$targetdir_dupplicates-all.txt"
	echo "Completed at $(date)"

}

search
exit 0
