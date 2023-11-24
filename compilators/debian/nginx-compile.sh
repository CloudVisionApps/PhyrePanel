#!/bin/bash

# Install dependencies
#apt install build-essential dpkg-dev debhelper autotools-dev libgeoip-dev libssl-dev libpcre3-dev zlib1g-dev

rm -rf "alphaXpanel-compilators"

mkdir "alphaXpanel-compilators"
mkdir "alphaXpanel-compilators/nginx"
cd "alphaXpanel-compilators/nginx"

#Download nginx source
wget http://nginx.org/download/nginx-1.20.0.tar.gz
tar -zxvf nginx-1.20.0.tar.gz
cd nginx-1.20.0

# Configure nginx
./configure --prefix=/usr/local/alphax/nginx
make
make install

mkdir alphax-nginx-1.20.0
cd alphax-nginx-1.20.0
mkdir DEBIAN
mkdir usr
mkdir usr/local
mkdir usr/local/alphax

mv /usr/local/alphax/nginx usr/local/alphax
cp control DEBIAN


