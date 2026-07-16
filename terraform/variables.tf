variable "aws_region" {
  default = "ap-south-1"
}

variable "instance_type" {
  default = "t2.micro"
}

variable "instance_name" {
  default = "CloudIt-Server"
}

variable "key_name" {
  description = "AWS Key Pair Name"
  type        = string
}

variable "ami_id" {
  description = "Ubuntu AMI"
  type        = string
}
