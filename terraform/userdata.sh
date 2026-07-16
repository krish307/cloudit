#!/bin/bash

sudo apt update -y

sudo apt install docker.io -y

sudo systemctl enable docker

sudo systemctl start docker
#!/bin/bash

apt update -y

apt install docker.io -y

systemctl enable docker

systemctl start docker

usermod -aG docker ubuntu