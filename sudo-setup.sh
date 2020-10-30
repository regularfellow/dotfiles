#!/bin/bash

# Check if https://electrictoolbox.com/check-user-root-sudo-before-running/
if [ `whoami` != root ]; then
    echo Run this script with sudo.
    exit
fi

# Update existing packages
echo "Update existing packages..."
apt update
apt upgrade -y

# Add erlang repo
echo "Add Erlang repo..."
wget https://packages.erlang-solutions.com/erlang-solutions_2.0_all.deb
dpkg -i erlang-solutions_2.0_all.deb
rm erlang-solutions_2.0_all.deb*

# Add gh repo
echo "Adding gh repo..."
apt-key adv --keyserver keyserver.ubuntu.com --recv-key C99B11DEB97541F0
apt-add-repository https://cli.github.com/packages

# Install packages
apt update
echo "Install packages..."
apt install -y postgresql mariadb-server mariadb-client esl-erlang elixir \
    python-is-python3 python3-pip python3-venv gh zsh stow inotify-tools libmysqlclient-dev

# Set postgres password to postgres
echo "Setting postgres password to postgres..."
echo -e "postgres\npostgres" | passwd postgres
sudo -u postgres psql -c "ALTER USER postgres PASSWORD 'postgres';"

# Set maria root password to empty
echo "Setting mariadb root password to empty..."
mysql -e "UPDATE mysql.user SET Password = PASSWORD('') WHERE User = 'root';"
mysql -e "UPDATE mysql.user SET plugin='mysql_native_password' WHERE User = 'root';"
mysql -e "FLUSH PRIVILEGES;"

SCRIPT_PATH=`realpath $0`
SCRIPT_DIR=`dirname $SCRIPT_PATH`

# Add postgresql configuration
echo "Adding postgresql configuration..."
POSTGRESQL_CONF=`sudo -u postgres psql -t -P format=unaligned -c 'SHOW config_file'`
POSTGRESQL_DIR=`dirname $POSTGRESQL_CONF`
ln -sf "$SCRIPT_DIR/postgresql/timezone.conf" "$POSTGRESQL_DIR/conf.d/60-timezone.conf"

# Add maria configuration
echo "Adding maria configuration..."
ln -sf "$SCRIPT_DIR/maria/timezone.cnf" "/etc/mysql/mariadb.conf.d/60-timezone.cnf"

# Start databases without sudo
echo "Installing databases sudoers file..."
rm /etc/sudoers.d/databases 2> /dev/null 
cp "$SCRIPT_DIR/sudoers.d/databases" /etc/sudoers.d/databases
chown root /etc/sudoers.d/databases
chmod 0440 /etc/sudoers.d/databases

# Start databases
echo "Start databases..."
service mysql start
service postgresql start

echo "Setup complete."
