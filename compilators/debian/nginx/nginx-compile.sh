#!/bin/bash

MAIN_DIR=$(pwd)

# Install dependencies
sudo apt-get update -y
sudo apt-get install build-essential dpkg-dev debhelper autotools-dev libgeoip-dev libssl-dev libpcre3-dev zlib1g-dev -y

#Download nginx source
wget http://nginx.org/download/nginx-1.20.0.tar.gz
tar -zxvf nginx-1.20.0.tar.gz
cd nginx-1.20.0

# Configure nginx
sudo ./configure --prefix=/usr/local/alphax/nginx
sudo make
sudo make install

sudo mkdir $MAIN_DIR/alphax-nginx-1.20.0
PACKAGE_MAIN_DIR=$MAIN_DIR/alphax-nginx-1.20.0

# Create debian package directories
sudo mkdir -p $PACKAGE_MAIN_DIR/DEBIAN
sudo mkdir -p $PACKAGE_MAIN_DIR/usr/local/alphax
sudo mkdir -p $PACKAGE_MAIN_DIR/etc/init.d

# Copy nginx compiled files
sudo mv /usr/local/alphax/nginx $PACKAGE_MAIN_DIR/usr/local/alphax

# Rename nginx to alpha-nginx
sudo mv $PACKAGE_MAIN_DIR/usr/local/alphax/nginx/sbin/nginx $PACKAGE_MAIN_DIR/usr/local/alphax/nginx/sbin/alpha-nginx

# Copy debian package META file
sudo cp $MAIN_DIR/control $PACKAGE_MAIN_DIR/DEBIAN

# Copy ALPHAX series files
sudo cp $MAIN_DIR/alphax $PACKAGE_MAIN_DIR/etc/init.d/alphax
sudo chmod +x $PACKAGE_MAIN_DIR/etc/init.d/alphax

# Make debian package
sudo dpkg-deb --build $PACKAGE_MAIN_DIR
sudo dpkg --info $MAIN_DIR/alphax-nginx-1.20.0.deb
sudo dpkg --contents $MAIN_DIR/alphax-nginx-1.20.0.deb

# Move debian package to dist folder
sudo mkdir -p $MAIN_DIR/dist
sudo mv $MAIN_DIR/alphax-nginx-1.20.0.deb $MAIN_DIR/dist
