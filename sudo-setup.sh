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
    python-is-python3 python3-pip gh zsh stow
