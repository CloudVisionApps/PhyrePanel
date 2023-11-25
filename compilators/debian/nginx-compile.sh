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

sudo mkdir alphax-nginx
cd alphax-nginx
sudo mkdir DEBIAN
sudo mkdir usr
sudo mkdir usr/local
sudo mkdir usr/local/alphax

sudo mv /usr/local/alphax/nginx usr/local/alphax
sudo cp $MAIN_DIR/control DEBIAN
cd ../

sudo dpkg-deb --build alphax-nginx
sudo dpkg --info alpahx-nginx.deb
sudo dpkg --contents alpahx-nginx.deb

sudo mv alphax-nginx.deb $MAIN_DIR/dist


cd $MAIN_DIR
ls
