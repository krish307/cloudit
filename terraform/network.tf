resource "aws_vpc" "cloudit" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name        = "CloudIt-VPC"
    Project     = "CloudIt"
    Environment = "development"
    ManagedBy   = "Terraform"
  }
}

resource "aws_internet_gateway" "cloudit" {
  vpc_id = aws_vpc.cloudit.id

  tags = {
    Name = "CloudIt-IGW"
  }
}

resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.cloudit.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "ap-southeast-2a"
  map_public_ip_on_launch = true

  tags = {
    Name = "CloudIt-Public-Subnet"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.cloudit.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.cloudit.id
  }

  tags = {
    Name = "CloudIt-Public-RT"
  }
}

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}