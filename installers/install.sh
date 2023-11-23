#!/bin/bash

# Check if the user is root
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root. Exiting..."
   exit 1
fi

# Check if the user is running a 64-bit system
if [[ $(uname -m) != "x86_64" ]]; then
    echo "This script must be run on a 64-bit system. Exiting..."
    exit 1
fi

# Check if the user is running a supported shell
if [[ $(echo $SHELL) != "/bin/bash" ]]; then
    echo "This script must be run on a system running Bash. Exiting..."
    exit 1
fi

# Check if the user is running a supported OS
if [[ $(uname -s) != "Linux" ]]; then
    echo "This script must be run on a Linux system. Exiting..."
    exit 1
fi

# Check if the user is running a supported distro
if [[ $(cat /etc/os-release | grep -w "ID_LIKE" | cut -d "=" -f 2) != "debian" ]]; then
    echo "This script must be run on a Debian-based system. Exiting..."
    exit 1
fi

