#!/bin/bash
MAIN_DIR="/alpha-x-panel/raw-repo"

apt install -y git
cd /
mkdir -p /alpha-x-panel/raw-repo
git clone https://github.com/CloudVisionApps/AlphaXPanel.git /alpha-x-panel/raw-repo

HELPERS_DIR=$MAIN_DIR"/shell/helpers/ubuntu"
. $HELPERS_DIR"/common.sh"
. $HELPERS_DIR"/create-mysql-db-and-user.sh"

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
    "php8.2-intl"
    "php8.2-pear"
    "php8.2-bcmath"
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
cp $MAIN_DIR/web/.env.example /usr/local/alpha-x-panel/web/.env.example

# Install Composer
cd /usr/local/alpha-x-panel/web

php8.2 -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
php8.2 -r "if (hash_file('sha384', 'composer-setup.php') === 'e21205b207c3ff031906575712edab6f13eb0b361f2085f1f1237b7126d785e826a450292b6cfd1d64d92e6563bbde02') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"
php8.2 composer-setup.php
php8.2 -r "unlink('composer-setup.php');"

COMPOSER_ALLOW_SUPERUSER=1 php8.2 composer.phar install --no-dev --optimize-autoloader --no-interaction

# Create database
PANEL_DB_NAME="alphaxpanel_db"
PANEL_DB_USER="alphaxpanel_user"
PANEL_DB_PASSWORD="alphaxpanel_password"
create_mysql_db_and_user $PANEL_DB_NAME $PANEL_DB_USER $PANEL_DB_PASSWORD

# Configure the application
cp .env.example .env

sed -i "s/^APP_NAME=.*/APP_NAME=AlphaXPanel/" .env
sed -i "s/^DB_DATABASE=.*/DB_DATABASE=$PANEL_DB_NAME/" .env
sed -i "s/^DB_USERNAME=.*/DB_USERNAME=$PANEL_DB_USER/" .env
sed -i "s/^DB_PASSWORD=.*/DB_PASSWORD=$PANEL_DB_PASSWORD/" .env
sed -i "s/^DB_CONNECTION=.*/DB_CONNECTION=mysql/" .env

php8.2 artisan key:generate
php8.2 artisan migrate
php8.2 artisan db:seed

sudo chmod -R o+w /usr/local/alpha-x-panel/web/storage/
sudo chmod -R o+w /usr/local/alpha-x-panel/web/bootstrap/cache/

#systemctl status php8.2-fpm.service
