#!/bin/bash

MAIN_DIR="/AlphaXPanel"
HELPERS_DIR=$MAIN_DIR"/shell/helpers/ubuntu"
. $HELPERS_DIR"/common.sh"

# Update the system
apt update && apt upgrade -y

REPOSITORIES_LIST=(
    "ppa:ondrej/php"
)

# Check if the repositories are installed
for REPOSITORY in "${REPOSITORIES_LIST[@]}"; do
  add-apt-repository -y $REPOSITORY
done

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
    "php8.2"
    "php8.2-fpm"
    "php8.2-cli"
    "php8.2-json"
    "php8.2-mysql"
    "php8.2-zip"
    "php8.2-gd"
    "php8.2-mbstring"
    "php8.2-curl"
    "php8.2-xml"
    "php8.2-pear"
    "php8.2-bcmath"
    "lsb-release"
    "gnupg2"
    "ca-certificates"
    "apt-transport-https"
    "software-properties-common"
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


# sudo ufw allow proto tcp from any to any port 80,443

# Run Nginx
systemctl start nginx
systemctl enable nginx

# Change NGINX index.html
rm -rf /var/www/html/*
cp $MAIN_DIR/samples/sample-index.html /var/www/html/index.html

# Add NGINX config
cp $MAIN_DIR/configurations/ubuntu/nginx/panel.conf /etc/nginx/sites-available/alphaxpanel.conf

# Create a symbolic link
if [ -f /etc/nginx/sites-enabled/alphaxpanel.conf ]; then
    rm -rf /etc/nginx/sites-enabled/alphaxpanel.conf
fi
ln -s /etc/nginx/sites-available/alphaxpanel.conf /etc/nginx/sites-enabled/alphaxpanel.conf

# Restart NGINX
systemctl restart nginx

mkdir -p /usr/local/alpha-x-panel/web
cp -r $MAIN_DIR/web/* /usr/local/alpha-x-panel/web

#systemctl status php8.2-fpm.service
