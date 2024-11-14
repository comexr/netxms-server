#!/usr/bin/env bash

# Tell this script to exit if there are any errors.
# You should have this in every custom script, to ensure that your completed
# builds actually ran successfully without any errors!
set -oue pipefail

# Your code goes here.
sudo dnf install -y postgresql-server
sudo postgresql-setup --initdb
sudo -u postgres createuser $USER
sudo -u postgres createdb -O $USER netxms