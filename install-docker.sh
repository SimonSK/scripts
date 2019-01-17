#!/bin/bash
# check if root
if [ "$EUID" -ne 0 ]; then
    echo "please run as root"
    exit 1
fi

# check if docker is already installed
docker -v >/dev/null 2>&1 >/dev/null
if [ "$?" -eq 0 ]; then
    echo "docker is already installed"
    exit 0
fi

# source: https://docs.docker.com/engine/installation/linux/ubuntu/#install-using-the-repository
# setup the repository for Docker CE
apt-get update -qq
apt-get install -qq -y \
    apt-transport-https \
    ca-certificates \
    curl \
    software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
apt-key fingerprint 0EBFCD88
# verify
echo "key fingerprint should be: 9DC8 5822 9FC7 DD38 854A E2D8 8D81 803C 0EBF CD88"
read -n1 -rsp $'Press any key to continue or Ctrl+C to exit...\n'
if [ "$key" != '' ]; then
    echo -e "\naborting..."
    exit 1
fi

echo "adding respository"
add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"

# install docker
echo "installing docker"
apt-get update -qq
apt-get install -qq -y docker-ce
