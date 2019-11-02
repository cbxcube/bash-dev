#!/usr/bin/env bash
#
# This script is just a collection of cool functions in Bash.
#

# BASH_TUNNING
# Force bash to stop on error and on failed piped output like "error here| true".
#set -o errexit
set -o pipefail

# Debuging of bash
set -o xtrace

# FUNCTIONS
#

# use: list top 10 used commands and their count
# arg: none
# out: none
func_freqcmds() {
	history | awk '{print $2}' | sort | uniq -c | sort -rn | head
}
# run:
printf "\n---\nfunc_freqcmds\n---\n" 
func_freqcmds

# use: clear blank lines and comments
# arg: $1 (mandatory): file to search. only one file is allowed
# out: clear 
func_clearcfg() {
	# check if parameter provided. if not exit
	local param
	if [ $# -gt 0 ]; then
		param="{$1}"
	# check if just one parameter is provided. if not exit
	elif [ $# -ne 1 ]; then
		printf "Parameter for func_clearcfg is required. Exiting.\n"
		exit 1
	elif [ $@ -ne 1 ]; then
		printf "Parameter for func_clearcfg is required. Exiting.\n"
		exit1
	fi
	# processing
	printf "\n - - - PROCESING TEXT FILE: Removing blank and commented lines\n"
	grep -E -v "^#|^$" "$1"
}
# run:
printf "\n---\nfunc_clearcfg\n---\n" 
func_clearcfg

# use: show difference between $@ and $#.
#      	$* is a single string, whereas $@ is an actual array. 
#	   	$# = number of arguments. Answer is 3
#		$@ = what parameters were passed. Answer is 1 2 3
#		$? = was last command successful. Answer is 0 which means 'yes'
# arg: more than one string is required
# out: none
func_parampars() {
	# print parameters
	echo '$#' $#
	echo '$@' $@
	echo '$?' $?

	# check if parameter provided. if not exit
	local param
	if [ $# -ne 0 ] && [ $# -gt 2 ]; then
		param="$@"
		printf "$#\n"
		printf "$@\n"
		printf "$*\n"
	else
		printf "More than one parameter is required. Exiting.\n"
		exit 1
	fi
	# various processing ways
	echo "Using \"\$*\":"
	for a in "$*"; do
	    echo $a;
	done
	
	echo -e "\nUsing \$*:"
	for a in $*; do
	    echo $a;
	done
	
	echo -e "\nUsing \"\$@\":"
	for a in "$@"; do
	    echo $a;
	done
	
	echo -e "\nUsing \$@:"
	for a in $@; do
	    echo $a;
	done 
}
# run:
printf "\n---\nfunc_parampars\n---\n"
func_parampars

# use: show difference between ${} and $()
# arg: 
# out: none
#func_bracketpars() {
#	# TBD
#}


# RUNTIME 
func_freqcmds
func_clearcfg
func_bracketpars

# END
printf "END OF JOB $(date)\n"
exit 0
