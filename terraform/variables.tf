variable "aws_region" {
  default = "ap-south-1"
}

variable "instance_type" {
  default = "t3.micro"
}

variable "instance_name" {
  default = "CloudIt-Server"
}

variable "key_name" {
  description = "AWS Key Pair Name"
  type        = string
}