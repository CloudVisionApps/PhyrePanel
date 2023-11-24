# Generate a random password
random_password="wfawfafwafwafaw"
email="wfafwafwa@abv.bg"

# Create the new alphaxweb user
#/usr/sbin/useradd "alphaxweb" -c "$email" --no-create-home
# do not allow login into alphaxweb user
echo alphaxweb:$random_password | sudo chpasswd -e

mkdir -p /etc/sudoers.d
cp -f /usr/local/alpha-x-panel/web/sudo/alphaxweb /etc/sudoers.d/
chmod 440 /etc/sudoers.d/alphaxweb
