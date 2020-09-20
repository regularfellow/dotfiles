#!/bin/bash

# Check if https://electrictoolbox.com/check-user-root-sudo-before-running/
if [ `whoami` == root ]; then
    echo Run this script as user.
    exit
fi

# Set shell to zsh
echo "Installing oh-my-zsh..."
chsh -s $(which zsh)
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
