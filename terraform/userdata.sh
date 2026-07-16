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

docker build -t cloudit:latest .

docker rm -f cloudit-web || true

docker run \
  --detach \
  --restart unless-stopped \
  --name cloudit-web \
  --publish 80:80 \
  cloudit:latest

docker ps