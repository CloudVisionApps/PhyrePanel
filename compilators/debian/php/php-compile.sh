#!/bin/bash

MAIN_DIR=$(pwd)

# Build Essentials
sudo apt-get install build-essential

# Install Dependencies
sudo apt install \
 autoconf \
 re2c \
 bison \
 sqlite3 \
 libsqlite3-dev \
 libpq-dev \
 libonig-dev \
 libfcgi-dev \
 libfcgi0ldbl \
 libjpeg-dev \
 libpng-dev \
 libssl-dev \
 libxml2-dev \
 libcurl4-openssl-dev \
 libxpm-dev \
 libgd-dev \
 libmysqlclient-dev \
 libfreetype6-dev \
 libxslt1-dev \
 libpspell-dev \
 libzip-dev \
 libicu-dev \
 libldap2-dev \
 libxslt-dev \
 libssl-dev \
 libldb-dev \
 libgccjit-10-dev \
 binutils \
 libtool \
 bison \
 re2c \
 pkg-config \
 zlib1g-dev \
 libargon2-dev \
 libsodium-dev \
 make \
 autoconf\
 automake

# Download PHP source
wget http://de2.php.net/distributions/php-8.2.0.tar.gz
tar -zxvf php-8.2.0.tar.gz
cd php-8.2.0

# Configure PHP

sudo ./configure --prefix=/usr/local/phyre/php \
    --enable-fpm --with-fpm-user=admin --with-fpm-group=admin \
				--with-openssl \
				--with-mysqli \
				--with-gettext \
				--with-curl \
				--with-zip \
				--enable-mbstring
#        --with-libdir=lib/$(arch)-linux-gnu

# Compile PHP
sudo make -jN
sudo make install

PACKAGE_MAIN_DIR=$MAIN_DIR/phyre-php-8.2.0
sudo mkdir $PACKAGE_MAIN_DIR

# Create debian package directories
sudo mkdir -p $PACKAGE_MAIN_DIR/DEBIAN
sudo mkdir -p $PACKAGE_MAIN_DIR/usr/local/phyre

# Copy php compiled files
sudo mv /usr/local/phyre/php $PACKAGE_MAIN_DIR/usr/local/phyre
sudo cp $MAIN_DIR/php-fpm.conf $PACKAGE_MAIN_DIR/usr/local/phyre/php/etc

# Copy debian package META file
sudo cp $MAIN_DIR/control $PACKAGE_MAIN_DIR/DEBIAN
sudo cp $MAIN_DIR/postinst $PACKAGE_MAIN_DIR/DEBIAN
sudo cp $MAIN_DIR/postrm $PACKAGE_MAIN_DIR/DEBIAN

# Set debian package post files permissions
sudo chmod +x $PACKAGE_MAIN_DIR/DEBIAN/postinst
sudo chmod +x $PACKAGE_MAIN_DIR/DEBIAN/postrm

# Make debian package
sudo dpkg-deb --build $PACKAGE_MAIN_DIR
sudo dpkg --info $MAIN_DIR/phyre-php-8.2.0.deb
sudo dpkg --contents $MAIN_DIR/phyre-php-8.2.0.deb

# Move debian package to dist folder
sudo mkdir -p $MAIN_DIR/dist
sudo mv $MAIN_DIR/phyre-php-8.2.0.deb $MAIN_DIR/dist
