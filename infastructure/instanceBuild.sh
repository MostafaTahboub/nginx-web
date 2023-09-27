#!/bin/sh
set -e

sudo apt update
sudo apt upgrade -y

sudo apt-get install -y ca-certificates curl gnupg
sudo install -m 0755 -d /etc/apt/keyrings

# install docker
for pkg in docker.io docker-doc docker-compose podman-docker containerd runc; do sudo apt-get remove $pkg; done

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg
# Add the repository to Apt sources:
echo \
    "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" |
    sudo tee /etc/apt/sources.list.d/docker.list >/dev/null
sudo apt update

sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# create github user
sudo mkdir -p /home/app
sudo useradd --no-create-home --home-dir /home/app --shell /bin/bash github
sudo usermod --append --groups docker github
sudo usermod --append --groups docker ubuntu
sudo chown github:github -R /home/app

github_pubkey='ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDGam4QFIylWZdCZog909UE9P2p29+kAcfgMH1/cDEA0R5+TR0pQLEg8MF++/vUQ1ZiG8H7j7I6uSgMK+46LlVtyd0IAC1xX+j82v1venkIg2MHGxHVx+2QFZzprPkPsZeJ0FgvYPjlHZz25hyZpdleD607rLHrnp4IjWSGFCmSgIKD5+k9rVWhuooAgKQMm13eSK91qpWlILCRu+irdD7cqvWFbBTALm+8XRQ3AWjlQHP2+UGQGPX+Qna8G5OTAfXA7DelMw6NbDrSZLGJ5ey8Cvia/qI++WvFoMIdMQ4HezGm96uD//qDOWc0T9W22tySSZeHCCPFt4sthhyKa+I3yEDMXPjRos9mWBp7pdY6l9J9hB71gseFwqvjwg+uRbZCEiph8R4pMW0jtKb5GXjVSiU4C3/sSb9fy5p/n6GzP5qIsjPkqqC47HesNkmSWAZxM55EvzXV4HMxF1T0YVU+sryY9DrJC/o+da87v4HJ1aikMfNkxLdoVxRzzzqw1qU= user@DESKTOP-3I78OE1'

sudo -u github sh -c "mkdir -p /home/app/.ssh && echo $github_pubkey > /home/app/.ssh/authorized_keys"

sudo reboot
