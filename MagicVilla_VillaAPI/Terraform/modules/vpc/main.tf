#################################
# VPC
#################################

resource "aws_vpc" "app_vpc" {
  cidr_block           = var.cidr_block
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name        = var.name
    Environment = var.environment
  }
}

#################################
# Internet Gateway
#################################

resource "aws_internet_gateway" "app_igw" {
  vpc_id = aws_vpc.app_vpc.id

  tags = {
    Name        = "${var.name}-igw"
    Environment = var.environment
  }
}

#################################
# Public Subnet
#################################

resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.app_vpc.id
  cidr_block              = var.public_subnet_cidr
  availability_zone       = var.availability_zone
  map_public_ip_on_launch = true

  tags = {
    Name        = "${var.name}-public-subnet"
    Environment = var.environment
  }
}

#################################
# Route Table
#################################

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.app_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.app_igw.id
  }

  tags = {
    Name        = "${var.name}-public-rt"
    Environment = var.environment
  }
}

#################################
# Route Table Association
#################################

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}
