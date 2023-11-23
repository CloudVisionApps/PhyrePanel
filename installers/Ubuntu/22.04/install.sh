#!/bin/bash

MAIN_DIR="/AlphaXPanel"
HELPERS_DIR=$MAIN_DIR"/shell/helpers/ubuntu"
. $HELPERS_DIR"/common.sh"

# Update the system
apt update && apt upgrade -y

DEPENDENCIES_LIST=(
    "curl"
    "wget"
    "git"
    "nginx"
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

DEPENDENCIES_FOR_REMOVE_LIST=(
    "apache2"
)
# Check if the dependencies are installed
for DEPENDENCY in "${DEPENDENCIES_FOR_REMOVE_LIST[@]}"; do
    if command_is_installed $DEPENDENCY; then
        echo "Dependency $DEPENDENCY is installed."
        echo "Removing $DEPENDENCY..."
        apt purge -y $DEPENDENCY
        apt autoremove -y
    fi
done

# Run Nginx
systemctl start nginx
systemctl enable nginx

rm -rf /var/www/html/*
cp $MAIN_DIR/samples/sample-index.html /var/www/html/index.html
