#!/bin/bash

MAIN_DIR=$(pwd)

# Install dependencies
sudo apt-get update -y
sudo apt-get install -y libzip-dev libonig-dev openssl zip unzip git ibgmp-dev gmp-dev libcurl4-openssl-dev libsqlite3-dev libxml2-dev pkg-config build-essential dpkg-dev debhelper autotools-dev libgeoip-dev libssl-dev libpcre3-dev zlib1g-dev

# Download PHP source
wget http://de2.php.net/distributions/php-8.2.0.tar.gz
tar -zxvf php-8.2.0.tar.gz
cd php-8.2.0

# Configure PHP

sudo ./configure --prefix=/usr/local/phyre/php \
        --with-libdir=lib/$(arch)-linux-gnu \
				--enable-fpm --with-fpm-user=admin --with-fpm-group=admin \
				--with-openssl \
				--with-mysqli \
				--with-gettext \
				--with-curl \
				--with-zip \
				--enable-mbstring

#sudo ./configure --prefix=/usr/local/phyre/php \
#  --enable-fpm --with-fpm-user=admin --with-fpm-group=admin

# Compile PHP
sudo make
sudo make install
