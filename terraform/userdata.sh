#!/bin/bash

set -euxo pipefail

exec > >(tee /var/log/cloudit-userdata.log | logger -t cloudit-userdata -s 2>/dev/console) 2>&1

export DEBIAN_FRONTEND=noninteractive

# Install prerequisites
apt-get update -y
apt-get install -y ca-certificates curl git

# Add Docker's official GPG key and repository
install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg \
  -o /etc/apt/keyrings/docker.asc
chmod a+r /etc/apt/keyrings/docker.asc

cat > /etc/apt/sources.list.d/docker.sources <<EOF
Types: deb
URIs: https://download.docker.com/linux/ubuntu
Suites: jammy
Components: stable
Architectures: $(dpkg --print-architecture)
Signed-By: /etc/apt/keyrings/docker.asc
EOF

# Install Docker Engine and Docker Compose
apt-get update -y
apt-get install -y \
  docker-ce \
  docker-ce-cli \
  containerd.io \
  docker-buildx-plugin \
  docker-compose-plugin

systemctl enable docker
systemctl start docker

usermod -aG docker ubuntu

# Verify installation
docker --version
docker compose version

# Deploy CloudIt
rm -rf /opt/cloudit
git clone "${repository_url}" /opt/cloudit

cd /opt/cloudit

docker compose up --build --detach
docker compose ps