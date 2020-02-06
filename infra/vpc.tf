resource "aws_vpc" "taa" {
  cidr_block           = "10.40.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name     = "taa-vpc"
    Resource = "taa"
  }
}

resource "aws_subnet" "taa1" {
  vpc_id = aws_vpc.taa.id
  availability_zone = "ap-northeast-1a"
  cidr_block = "10.40.0.0/20"
  map_public_ip_on_launch = true
  tags = {
    Name     = "taa-subnet1"
    Resource = "taa"
  }
}

resource "aws_subnet" "taa2" {
  vpc_id = aws_vpc.taa.id
  availability_zone = "ap-northeast-1a"
  cidr_block = "10.40.16.0/20"
  map_public_ip_on_launch = true
  tags = {
    Name     = "taa-subnet2"
    Resource = "taa"
  }
}

resource "aws_internet_gateway" "taa" {
  vpc_id = aws_vpc.taa.id
  tags = {
    Name     = "taa-igw"
    Resource = "taa"
  }
}

resource "aws_route_table" "taa" {
  vpc_id = aws_vpc.taa.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.taa.id
  }
  tags = {
    Name     = "taa-routing-table"
    Resource = "taa"
  }
}

resource "aws_route_table_association" "taa1" {
  subnet_id      = aws_subnet.taa1.id
  route_table_id = aws_route_table.taa.id
}
