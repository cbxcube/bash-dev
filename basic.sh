#!/usr/bin/env bash
# This is your next program which you can pull with git to your desktop and execute from terminal with:  "sudo ./do-next.sh"

# Clean screen before program kicks off
clear

# Define function which will print separator on standard output
makemeline() {
      echo "--------------------------------------------------------"
}

# Print separator here
makemeline

# Notify user that the program has started
echo "Starting program run at $(date) ...by user...$(whoami).........."
makemeline

# Next step of program requires binaries "uname", "hostname" and "df". If any of them is missing
# we need to terminate program run here with exit code "1" = error!
# (Note: exit 0 => success; exit 1 => fail)
# Disclaimer: This test is just an example. All listed binaries are part of base installation in each OSX/Linux!

echo "Checking guest OS prerequisities.........................."

if uname >/dev/null 2>&1; then
    echo "Binary "uname" found on guest OS......................... PASS"
else
    echo "Binary "uname" NOT FOUND on guest OS.................... ERROR!"
    echo "To fix this please run:"
    echo "OSX: sudo brew install uname"
    echo "Debian/Ubuntu: sudo apt install uname"
    echo "Program exited with ERROR! .....$(date).................EXITING!"
    makemeline
    exit 1
fi

if hostname >/dev/null 2>&1; then
    echo "Binary "hostname" found on guest OS...................... PASS"
else
    echo "Binary "hostname" NOT FOUND on guest OS................. ERROR!"
    echo "To fix this please run:"
    echo "OSX: sudo brew install hostname"
    echo "Debian/Ubuntu: sudo apt install hostname"
    echo "Program exited with ERROR! .....$(date)..................EXITING!"
    exit 1
    makemeline
fi

if df >/dev/null 2>&1; then
    echo "Binary "df" found on guest OS.....................,........ PASS"
else
    echo "Binary "df" NOT FOUND on guest OS..........,.............. ERROR!"
    echo "To fix this please run:"
    echo "OSX: sudo brew install df"
    echo "Debian/Ubuntu: sudo apt install df"
    echo "Program exited with ERROR! .....$(date)...................EXITING!"
    exit 1
    makemeline
fi


# Program will sleep here for 5 seconds to pretend it's doing somethihng really intensive...
sleep 5

# Define variables for some machine details
mysystem=$(uname -a)
myhostname=$(hostname)
mykernel=$(uname -r)
myarchitecture=$(uname -i)
myrootfs=$(df -h /)

# Printing some details about your machine
makemeline
echo "Gathering information about your system..."
sleep 1
makemeline
echo "Details about guest OS   : $mysystem"
echo "Guest OS hostname        : $myhostname"
echo "Guest OS kernel version  : $mykernel"
echo "Guest OS architecture    : $myarchitecture"
echo "Utilisation of root FS   : $myrootfs"
makemeline

# Notify user that the program is about to finish
echo "Finishing program run at $(date)."
makemeline

# Exit program gracefully with exit code "0" = success. (Note: exit 0 => success; exit 1 => fail)
exit 0
