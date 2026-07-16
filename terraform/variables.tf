variable "aws_region" {
  description = "AWS region where CloudIt resources will be created"
  type        = string
  default     = "ap-southeast-2"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "instance_name" {
  description = "Name tag for the CloudIt EC2 instance"
  type        = string
  default     = "CloudIt-Server"
}

variable "key_name" {
  description = "Existing AWS EC2 key-pair name"
  type        = string
}

variable "ssh_cidr" {
  description = "Public IPv4 address allowed to connect through SSH, in CIDR format"
  type        = string
}

variable "repository_url" {
  description = "Public GitHub repository cloned during instance startup"
  type        = string
  default     = "https://github.com/krish307/cloudit.git"
}