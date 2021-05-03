  
#!/bin/bash -e

# Stop and disable apt-daily upgrade services;
sudo systemctl stop apt-daily.timer
sudo systemctl disable apt-daily.timer
sudo systemctl disable apt-daily.service
sudo systemctl stop apt-daily-upgrade.timer
sudo systemctl disable apt-daily-upgrade.timer
sudo systemctl disable apt-daily-upgrade.service

# Enable retry logic for apt up to 10 times
sudo echo "APT::Acquire::Retries \"10\";" > /etc/apt/apt.conf.d/80-retries

# Configure apt to always assume Y
sudo echo "APT::Get::Assume-Yes \"true\";" > /etc/apt/apt.conf.d/90assumeyes

# Uninstall unattended-upgrades
apt-get purge unattended-upgrades

# Use apt-fast for parallel downloads
# deb http://ppa.launchpad.net/apt-fast/stable/ubuntu bionic main 
# REPO_URL="ppa:apt-fast/stable"
# apt-add-repository $REPO_URL -y
bash -c "$(curl -sL https://git.io/vokNn)"

apt-get update

sudo rm -r /etc/apt/sources.list.d/apt-fast-*
# add-apt-repository -y ppa:apt-fast/stable

# Need to limit arch for default apt repos due to 
# https://github.com/actions/virtual-environments/issues/1961
sudo sed -i'' -E 's/^deb http:\/\/(azure.archive|security).ubuntu.com/deb [arch=amd64,i386] http:\/\/\1.ubuntu.com/' /etc/apt/sources.list

sudo echo 'APT sources limited to the actual architectures'
sudo cat /etc/apt/sources.list

apt-get update
# Install aria2 , jq and apt-fast
apt-get install aria2 jq 