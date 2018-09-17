#!/bin/bash

# awscli
# 
# Install the awscli 
#
# Requirements:
# 	sudo user
#	python3
#	pip3


# Verify super user access
if [ "$EUID" -ne 0 ]; then
	echo "Please run as root user"
	exit
fi

# Verify pip3 installed
sudo apt-get install python3-pip

# Install the cli
pip3 install awscli --upgrade 
