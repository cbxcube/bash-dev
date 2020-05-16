#!/usr/bin/env bash
# find duplicates using fdupe binary

targetdir="$1"
spacebefore=$(du -xms $targetdir)
resultsfile=$targetdir$targetdir_duplicates-DUPLICATES_all.txt
resultsfileomitted=$targetdir$targetdir_duplicates-DUPLICATES_onlyommited.txt

if [ $# -gt 0 ]; then
	echo "Duplfinder started................................................................. Date: $(date)."
	echo "Starting to look for duplicates in directory: $targetdir." 
	echo "Size of target: $spacebefore."
	echo "............................................................................................................"
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

	if	[ -e  $resultsfile ]; then
		resultsfile2=/tmp/$targetdir_duplicates-DUPLICATES2-all.txt
		echo "File for duplicates result $resultsfile2 already exist."
		echo "Creating Result file in user's home $resultsfile2"
		touch "$resultsfile2"
		ls -l "$resultsfile2"
		echo "Duplicates will be listed in file: $resultsfile2." 
	        echo ""	
		resultsfile=$resultsfile2

	elif 	[ ! -f $resultsfile ]; then
		echo "File for duplicates result $resultsfile created."
		touch "$resultsfile" 
		ls -l "$resultsfile"
		echo "Duplicates will be listed in file: $resultsfile." 
		echo ""

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

    echo "Duplicates detected...................................."
    echo ""
    while IFS= read -r line; do
	    printf '%q\n' "$line"|grep -v "^''" 
    done < $resultsfile
    echo ""

    while IFS= read -r line; do
	    ls -l "$line" 2>/dev/null 
    done < $resultsfile
    echo ""

    while IFS= read -r line; do
            /usr/bin/md5sum "$line" 2>/dev/null 
    done < $resultsfile
    echo ""
}


todelete() {

    echo "======================================================================"
    echo "RESULTS: Duplicates safe to delete...................................."
    echo ""
    while IFS= read -r line; do
	    printf '%q\n' "$line"|grep -v "^''" 
    done < $resultsfileomitted
    echo "......................................................................"
    echo "======================================================================"
}


# executing
createresults
search
search-omitted
removespaces
todelete

exit 0
