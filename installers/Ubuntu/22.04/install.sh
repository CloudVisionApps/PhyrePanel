#!/bin/bash

HELPERS_DIR="$(dirname "$(pwd)")/shell/helpers/ubuntu"
. $HELPERS_DIR"/common.sh"

# Update the system
apt update && apt upgrade -y

DEPENDENCIES_LIST=(
    "curl"
    "wget"
    "git"
    "nodejs"
    "npm"
    "unzip"
    "zip"
    "tar"
    "php"
)
# Check if the dependencies are installed
for DEPENDENCY in "${DEPENDENCIES_LIST[@]}"; do
    if ! command_is_installed $DEPENDENCY; then
        echo "Dependency $DEPENDENCY is not installed."
        echo "Installing $DEPENDENCY..."
        apt install -y $DEPENDENCY
    else
        echo "Dependency $DEPENDENCY is installed."
    fi
done
