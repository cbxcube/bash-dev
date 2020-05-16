#!/usr/bin/env bash
# find duplicates using fdupe binary

targetdir=$1
spacebefore=$(du -xms $targetdir)
resultsfile=$targetdir$targetdir_duplicates-all.txt
resultsfileomitted=$targetdir$targetdir_duplicates-ommited.txt

if [ $# -gt 0 ]; then
	echo "Starting to look for duplicates in directory: $targetdir - $(date)."
	echo "Size of target: $targetdir - $spacebefore."
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




createresults() {

	if	[ -f  $resultsfile ]; then
		resultsfile2="~$targetdir_duplicates-all.txt"
		echo "File for duplicates result $resultsfile2 already exist."
		echo "Creating Result file in user's home $resultsfile2"
		touch $resultsfile2
		ls -l $resultsfile2
		resultsfile=$resultsfile2

	elif 	[ ! -f $resultsfile ]; then
		touch $resultsfile 
		ls -l $resultsfile 
		echo "Duplicates will be listed in file: $resultsfile." 

	else
		echo "Failed to create the file: $resultsfile"
		exit 1
	fi

}

search() {

	fdupes -r $targetdir > $resultsfile
	echo "Completed at $(date)"
}

search-omitted() {

	fdupes -rf $targetdir > $resultsfileomitted
	echo "Completed at $(date)"
}

#escapingresults1() {
	#sed -i  $resultsfile
	#echo "Completed at $(date)"
#}


# sed Replaced with IFS
## sed 
#cat duplicates-confidential-omitfirst-dup-match.txt |sed 's/\ /\\ /g;s/(/\\(/g;s/)/\\)/g' > duplicates-confidential-omitfirst-dup-match2.txt
#
## check paths 
#for i in $(cat duplicates-confidential-omitfirst-dup-match2.txt); do ls $i; done
#
#

#If you find the < <(command) syntax unfamiliar you should read about process substitution. 
#The advantage of this over for file in $(find ...) is that files with spaces, newlines and other characters are correctly handled. 
#This works because find with -print0 will use a null (aka \0) as the terminator for each file name and, unlike newline, null is not a 
#legal character in a file name.


removespaces() {

    while IFS= read -r line; do
	    printf '%q\n' "$line"
    done < $resultsfile
}

# executing
createresults
search
search-ommited
removespaces

exit 0
