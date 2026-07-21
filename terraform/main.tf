data "aws_vpc" "default" {
  default = true
}

data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name = "name"

    values = [
      "ubuntu/images/hvm-ssd-gp3/ubuntu-jammy-22.04-amd64-server-*",
      "ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"
    ]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
}

resource "aws_security_group" "cloudit_sg" {
  name_prefix = "cloudit-sg-"
  description = "Security group for the CloudIt web server"
  vpc_id = aws_vpc.cloudit.id

  ingress {
    description = "SSH administration"

    from_port = 22
    to_port   = 22
    protocol  = "tcp"

    cidr_blocks = [var.ssh_cidr]
  }

  ingress {
    description = "Public HTTP traffic"

    from_port = 80
    to_port   = 80
    protocol  = "tcp"

    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow outbound traffic"

    from_port = 0
    to_port   = 0
    protocol  = "-1"

    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "CloudIt-SG"
    Project     = "CloudIt"
    Environment = "development"
    ManagedBy   = "Terraform"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_instance" "cloudit_server" {
  subnet_id = aws_subnet.public.id

vpc_security_group_ids = [
  aws_security_group.cloudit_sg.id
]
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type
  key_name      = var.key_name

  associate_public_ip_address = true

  
 user_data = templatefile("${path.module}/userdata.sh", {
  repository_url = var.repository_url
})
  user_data_replace_on_change = true

  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "required"
  }

  root_block_device {
    volume_type           = "gp3"
    volume_size           = 10
    encrypted             = true
    delete_on_termination = true
  }

  tags = {
    Name        = var.instance_name
    Project     = "CloudIt"
    Environment = "development"
    ManagedBy   = "Terraform"
  }
}