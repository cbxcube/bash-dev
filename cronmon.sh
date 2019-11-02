#!/usr/bin/env bash

# This script is monitoring cron job each 1 minute.
# It will run the job manually in case the cron was not working for some reason.
# It will reset root password to "well known one" if root password will be expired.


# BASH_TUNNING
# Force bash to stop on error and on failed piped output like "error here| true".
#set -o errexit
set -o pipefail

# Debuging of bash
set -o xtrace


# VARIABLES
script_name="cron_minute_test"
UID=""
UID="root"
#UID="${whoami}"
#UID="root"

arg1="$($1)"
arg2="$($2)"
arg3="$($3)"

lock_dir="/var/tmp/$script_name.$UID.lock"
log_dir="/var/tmp/$script_name.$UID.log"

# FUCTIONS
# 1. check if root password is expired and reset it in case it is
# 2. check if crond is running and start it if not
# 3. check output of last log file of job "/home/cubic/Dropbox/scripts/bash/minute_test.sh"
# 4. lock file will be generated
# 5. cron_init function will be defined


# DESC: Usage help
# ARGS: None
# OUTS: None
function script_usage() {
    cat << EOF
Usage:
     -h|--help                  Displays this help
     -v|--verbose               Displays verbose output
    -nc|--no-colour             Disables colour output
    -cr|--cron                  Run silently unless we encounter an error
EOF
}

# DESC: Parameter parser
# ARGS: $@ (optional): Arguments provided to the script
# OUTS: Variables indicating command-line parameters and options
function parse_params() {
    local param
    while [[ $# -gt 0 ]]; do
        param="$1"
        shift
        case $param in
            -h|--help)
                script_usage
                exit 0
                ;;
            -v|--verbose)
                verbose=true
                ;;
            -nc|--no-colour)
                no_colour=true
                ;;
            -cr|--cron)
                cron=true
                ;;
            *)
                script_exit "Invalid parameter was provided: $param" 2
                ;;
        esac
    done
}

function adddate() {
    while IFS= read -r line; do
        printf '%s %s\n' "$(date)" "$line";
    done
}

function crond_check() {
	/etc/init.d/cron status
	if [ $? -eq 0 ]; then
		printf '%s %s\n'"Crond is running" | adddate >> "${log_dir}"
	else
		printf '%s %s\n'"Crond is NOT running" | adddate >> "${log_dir}"
        exit 1
	fi
}




# RUNTIME
parse_params
crond_check
