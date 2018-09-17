#!/bin/bash

if [ "$EUID" -ne 0 ]; then
	echo "Please run as sudo"
	exit
fi

# Add the MongoDB repo
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv EA312927
echo "deb http://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.2 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-3.2.list
sudo apt update

# Install MongoDB
sudo apt install -y mongodb-org
sudo systemctl start mongod 	# start as service
sudo systemctl status mongod	# verify service is running
sudo systemctl enable mongod	# enable to run at startup

# Adjust the firewall for outside connections
# sudo ufw allow from some_cloud_server_ip/32 to any port 27017
sudo ufw allow 27017

# Don't foreget to enable AUTH and set the administrator
# From the mongo cli
# use my_database
# db.createuser (
#	{
#		user: "myUserAdmin",
#		pwd: "myComplexPassword",
#		roles ["userAdminAnyDatabase"]
#	}
# )

# Update the config file
CONF=$(pwd)/mongod.conf
if [ -f $CONF ]; then
	sudo cp $CONF /etc
else
	echo "No config file found. Are you in /path/to/supportscripts/mongo ?"
	exit -1
fi

# Restart for config to take action
sudo systemctl restart mongod
sudo systemctl status mongod
