#!/bin/bash

set -euxo pipefail

exec > >(tee /var/log/cloudit-userdata.log | logger -t cloudit-userdata -s 2>/dev/console) 2>&1

export DEBIAN_FRONTEND=noninteractive

apt-get update -y
apt-get install -y docker.io git curl

systemctl enable docker
systemctl start docker

usermod -aG docker ubuntu

rm -rf /opt/cloudit

git clone "${repository_url}" /opt/cloudit

cd /opt/cloudit

apt-get install -y docker-compose-plugin

docker compose up --build --detach

docker compose ps