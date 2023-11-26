#!/bin/bash
MAIN_DIR="/phyre/raw-repo"

apt-get update && apt-get install ca-certificates

apt install -y git
cd /
mkdir -p $MAIN_DIR
git clone https://github.com/CloudVisionApps/PhyrePanel.git $MAIN_DIR

HELPERS_DIR=$MAIN_DIR"/shell/helpers/ubuntu"
. $HELPERS_DIR"/common.sh"
. $HELPERS_DIR"/create-mysql-db-and-user.sh"


# Create the new phyreweb user

random_password="$(openssl rand -base64 32)"
email="admin@phyrepanel.com"

# Create the new phyreweb user
/usr/sbin/useradd "phyreweb" -c "$email" --no-create-home

# do not allow login into phyreweb user
echo phyreweb:$random_password | sudo chpasswd -e

mkdir -p /etc/sudoers.d
cp -f $MAIN_DIR/installers/Ubuntu/22.04/sudo/phyreweb /etc/sudoers.d/
chmod 440 /etc/sudoers.d/phyreweb


# Update the system
apt update -y

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
    "mysql-common"
    "mysql-server"
    "mysql-client"
    "lsb-release"
    "gnupg2"
    "ca-certificates"
    "apt-transport-https"
    "software-properties-common"
    "supervisor"
    "libonig-dev"
    "libzip-dev"
    "libcurl4-openssl-dev"
    "libssl-dev"
    "libldb-dev"
    "libgccjit-10-dev"
    "libargon2-dev"
    "zlib1g-dev"
    "php8.2"
    "php8.2-fpm"
    "php8.2-mysql"
    "php8.2-curl"
    "php8.2-gd"
    "php8.2-intl"
    "php8.2-mbstring"
    "php8.2-xml"
    "php8.2-zip"
    "php8.2-bcmath"
    "php8.2-imagick"
    "php8.2-redis"
    "php8.2-igbinary"
    "php8.2-memcached"
    "php8.2-mongodb"
    "php8.2-ssh2"
    "php8.2-ldap"
    "php8.2-xmlrpc"
    "php8.2-soap"
    "php8.2-yaml"
    "php8.2-dev"
    "php8.2-sqlite3"
    "php8.2-swoole"
    "php8.2-ast"
    "php8.2-geoip"
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

#DEPENDENCIES_FOR_REMOVE_LIST=(
#    "apache2"
#)
## Check if the dependencies are installed
#for DEPENDENCY in "${DEPENDENCIES_FOR_REMOVE_LIST[@]}"; do
#    if command_is_installed $DEPENDENCY; then
#        echo "Dependency $DEPENDENCY is installed."
#        echo "Removing $DEPENDENCY..."
#        apt purge -y $DEPENDENCY
#        apt autoremove -y
#    fi
#done

# Install PHYRE NGINX
sudo dpkg -i $MAIN_DIR/compilators/debian/nginx/dist/phyre-nginx-1.24.0.deb

# Install PHYRE PHP
sudo dpkg -i $MAIN_DIR/compilators/debian/php/dist/phyre-php-8.2.0.deb

# sudo ufw allow proto tcp from any to any port 80,443

# Run Nginx
systemctl start nginx
systemctl enable nginx

# Change NGINX index.html
rm -rf /var/www/html/*
cp $MAIN_DIR/samples/sample-index.html /var/www/html/index.html

# Restart NGINX
systemctl restart nginx

PHYRE_PHP=/usr/local/phyre/php/bin/php

mkdir -p /usr/local/phyre/web
cp -r $MAIN_DIR/web/* /usr/local/phyre/web
cp $MAIN_DIR/web/.env.example /usr/local/phyre/web/.env.example

# Install Composer
cd /usr/local/phyre/web

$PHYRE_PHP -v
$PHYRE_PHP -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
$PHYRE_PHP -r "if (hash_file('sha384', 'composer-setup.php') === 'e21205b207c3ff031906575712edab6f13eb0b361f2085f1f1237b7126d785e826a450292b6cfd1d64d92e6563bbde02') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"
$PHYRE_PHP ./composer-setup.php
$PHYRE_PHP -r "unlink('composer-setup.php');"

COMPOSER_ALLOW_SUPERUSER=1 $PHYRE_PHP ./composer.phar install --no-dev --optimize-autoloader --no-interaction

# Create database
PANEL_DB_NAME="phyredb"
PANEL_DB_USER="phyreuser"
PANEL_DB_PASSWORD="phyrepass"
create_mysql_db_and_user $PANEL_DB_NAME $PANEL_DB_USER $PANEL_DB_PASSWORD

# Configure the application
cp .env.example .env

sed -i "s/^APP_NAME=.*/APP_NAME=PhyrePanel/" .env
sed -i "s/^DB_DATABASE=.*/DB_DATABASE=$PANEL_DB_NAME/" .env
sed -i "s/^DB_USERNAME=.*/DB_USERNAME=$PANEL_DB_USER/" .env
sed -i "s/^DB_PASSWORD=.*/DB_PASSWORD=$PANEL_DB_PASSWORD/" .env
sed -i "s/^DB_CONNECTION=.*/DB_CONNECTION=mysql/" .env

$PHYRE_PHP artisan key:generate
$PHYRE_PHP artisan migrate
$PHYRE_PHP artisan db:seed

sudo chmod -R o+w /usr/local/phyre/web/storage/
sudo chmod -R o+w /usr/local/phyre/web/bootstrap/cache/
