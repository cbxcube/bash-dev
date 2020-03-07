#! /usr/bin/env bash
#
# Configure service with response file

# Get scripts PID:
runpid="echo $$"

# Variables:
path=/sbin:/bin:/usr/sbin:/usr/bin
name="sample_application"
desc="Sample application bash script for installation and configuration with response file"
lockfile=~/.configsh0.lock
lockfile2=~/.configsh1.lock
pidfile=~/.configsh.pid

destin=/tmp/sample
respf=~/configsh.conf

default_run=installation

# Banner:
banner() {
	echo "=============================================================================================="
}

# Functions:
mklockf() {
	lockid=$1
	if [ $lockid=0 ]; then
		lockfileid=$lockfile
		echo "$(date) $runpid" >> $lockfileid
	else
		lockfileid=$lockfile2
		echo "$(date) $runpid - Child PID." >> $lockfileid
	fi
}


# Prerequisites check:
test -f $destin || echo "" && echo "ERROR: Prerequisites check failure - Destination path not created. Exiting..." && exit 0
test -f $respf || echo "" && echo "ERROR: Prerequisites check failure - Response file missing. Exiting..." && exit 0


# Source variables from response file:
if [ -r $respf ]; then
	. $respf
fi


# Operations:
startinst() {
	# Return codes:
	# 0 if installation has been started
	# 1 if installation was already running
	# 2 if installation could not be started
	# Parameters:
	# --test 	check if installation is already running
	# --start	
	# --quiet	quiet installation
	# --swname	software to deploy
	if [ -f $lockfile2 ]; then
		echo "ERROR: Another operation in progress. Lock file detected. Exiting... "
		exit 0
	else
		#Parameter for mklockf function is required - use 0 for log1, else [1-9] for log2
		mklockf 1 
		echo "OK: Lock file for INSTALLATION operation created."
	fi

	installation --test --start --quiet \
		--destination $destin --swname $swname --startas $default_run \
		>/dev/null \
		|| return 1

	installation --start --quiet \
		--destination $destin --swname $swname --startas $default_run \
		-- $OPTIONS \
		|| return 2
}

configureinst(){

	if [ -r $lockfile2 != "true" ]; then
		return 0
	fi

	# Return
	#   0 if configuration has been stopped
	#   1 if configuration was already stopped
	#   2 if configuration could not be stopped
	#   other if a failure occurred
	configuration --test --start --quiet \
		--destination $destin --swname $swname --startas $default_run \
		>/dev/null \
		|| return 1

	configuration --start --quiet \
		--destination $destin --swname $swname --startas $default_run \
		-- $OPTIONS \
		|| return 2


}



# Case:
case "$1" in
  installation)
	echo "Starting installation"
	#if [ "$run_daemon" != "true" ]; then
	#	log_warning_msg "To run the ptunnel daemon, please set run_daemon to 'true' in /etc/default/ptunnel "
	#	log_end_msg 0
	#	exit 0
	#fi
	#[ "$VERBOSE" != no ] && log_daemon_msg "Starting $DESC" "$NAME"
	#do_start
	#case "$?" in
	#	0|1) [ "$VERBOSE" != no ] && log_end_msg 0 ;;
	#	2) [ "$VERBOSE" != no ] && log_end_msg 1 ;;
	#esac
	#;;

	#

  configuration)
	  echo ""
	  ;;



  *)
	# echo "Usage: $N {installation|configuration}" >&2
	exit 1
	;;
esac


exit 0
