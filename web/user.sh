# Generate a random password
random_password="wfawfafwafwafaw"
email="wfafwafwa@abv.bg"

# Create the new phyreweb user
/usr/sbin/useradd "phyreweb" -c "$email" --no-create-home

# do not allow login into phyreweb user
echo phyreweb:$random_password | sudo chpasswd -e

mkdir -p /etc/sudoers.d
cp -f /usr/local/phyre/web/sudo/phyreweb /etc/sudoers.d/
chmod 440 /etc/sudoers.d/phyreweb
