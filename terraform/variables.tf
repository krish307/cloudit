variable "aws_region" {
  description = "AWS Region where resources will be created"
  type        = string
  default     = "ap-south-1"
}

variable "instance_type" {
  description = "EC2 Instance Type"
  type        = string
  default     = "t3.micro"
}

variable "instance_name" {
  description = "Name of the EC2 Instance"
  type        = string
  default     = "CloudIt-Server"
}