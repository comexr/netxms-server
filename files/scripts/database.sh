#!/usr/bin/env bash

# Tell this script to exit if there are any errors.
# You should have this in every custom script, to ensure that your completed
# builds actually ran successfully without any errors!
set -oue pipefail

# Setup database
sudo dnf install -y postgresql-server
sudo postgresql-setup --initdb #Initialize
sudo systemctl enable --now postgresql #Enable and start postgresql server
sudo -u postgres createuser $USER #Create DB user
sudo -u postgres createdb -O $USER netxms #Create DB for user
sudo sed -i "1s/^/host netxms $USER localhost trust\n/" /var/lib/pgsql/data/pg_hba.conf #Allow local user DB auth

#Connect database
echo -e "\nDBDriver=pgsql\nDBName=netxms\nDBLogin=$USER" | sudo tee -a /etc/netxmsd.conf
sudo systemctl restart postgresql
nxdbmgr init pgsql

#Shutdown database after netxms
sudo mkdir -p /etc/systemd/system/netxms-server.service.d && echo -e "[Unit]\nAfter=network.target postgresql.service" | sudo tee /etc/systemd/system/netxms-server.service.d/override.conf