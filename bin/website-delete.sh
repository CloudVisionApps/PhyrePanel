#!/bin/bash

# Path to NGINX sites-available directory
sites_available_dir="/etc/nginx/sites-available"
sites_enabled_dir="/etc/nginx/sites-enabled"

# Delete the site
rm -rf $sites_available_dir/$1
rm -rf $sites_enabled_dir/$1

# Reload NGINX
service nginx reload

echo "Deleted site $1"
echo "done!"
