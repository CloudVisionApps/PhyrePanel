#!/bin/bash

function create_mysql_db_and_user() {

  echo "Creating MySQL user and database"

  PASS=$3
  if [ -z "$3" ]; then
    PASS=`openssl rand -base64 8`
  fi

  mysql -u root <<MYSQL_SCRIPT
  CREATE DATABASE $2;
  CREATE USER '$1'@'localhost' IDENTIFIED BY '$PASS';
  GRANT ALL PRIVILEGES ON $2.* TO '$1'@'localhost';
  FLUSH PRIVILEGES;
MYSQL_SCRIPT

  echo "MySQL user and database created."
  echo "Username: $1"
  echo "Database: $1"
  echo "Password: $PASS"

}
