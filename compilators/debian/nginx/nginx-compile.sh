#!/bin/bash

MAIN_DIR=$(pwd)

# Install dependencies
apt install build-essential dpkg-dev debhelper autotools-dev libgeoip-dev libssl-dev libpcre3-dev zlib1g-dev

#Download nginx source
wget http://nginx.org/download/nginx-1.20.0.tar.gz
tar -zxvf nginx-1.20.0.tar.gz
cd nginx-1.20.0

# Configure nginx
sudo ./configure --prefix=/usr/local/alphax/nginx
sudo make
sudo make install

sudo mkdir $MAIN_DIR/alphax-nginx-1.20.0
cd $MAIN_DIR/alphax-nginx-1.20.0
sudo mkdir $MAIN_DIR/DEBIAN
sudo mkdir $MAIN_DIR/usr
sudo mkdir $MAIN_DIR/usr/local
sudo mkdir $MAIN_DIR/usr/local/alphax
sudo mkdir $MAIN_DIR/etc/init.d

sudo mv /usr/local/alphax/nginx/sbin/nginx $MAIN_DIR/usr/local/alphax/nginx/sbin/alpha-nginx
sudo mv /usr/local/alphax/nginx $MAIN_DIR/usr/local/alphax
sudo cp $MAIN_DIR/control DEBIAN

sudo cp $MAIN_DIR/etc/init.d/alphax $MAIN_DIR/alphax
sudo chmod +x $MAIN_DIR/etc/init.d/alphax
ls

cd ../

sudo dpkg-deb --build alphax-nginx-1.20.0
sudo dpkg --info alphax-nginx-1.20.0.deb
sudo dpkg --contents alphax-nginx-1.20.0.deb

sudo mv alphax-nginx-1.20.0.deb $MAIN_DIR/dist

cd $MAIN_DIR
ls
