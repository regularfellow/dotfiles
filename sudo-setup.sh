#!/bin/bash

# Check if https://electrictoolbox.com/check-user-root-sudo-before-running/
if [ `whoami` != root ]; then
    echo Run this script with sudo.
    exit
fi
