resource "aws_vpc" "taa" {
  cidr_block           = "10.40.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name     = "taa-vpc"
    Resource = "taa"
  }
}

resource "aws_subnet" "taa_sub_pub" {
  vpc_id = aws_vpc.taa.id
  availability_zone = "ap-northeast-1a"
  cidr_block = "10.40.0.0/20"
  map_public_ip_on_launch = true
  tags = {
    Name     = "taa-subnet-pub"
    Resource = "taa"
  }
}

resource "aws_subnet" "taa_sub_priv1" {
  vpc_id = aws_vpc.taa.id
  availability_zone = "ap-northeast-1a"
  cidr_block = "10.40.16.0/20"
  map_public_ip_on_launch = true
  tags = {
    Name     = "taa-subnet-priv-1"
    Resource = "taa"
  }
}

resource "aws_subnet" "taa_sub_priv2" {
  vpc_id = aws_vpc.taa.id
  availability_zone = "ap-northeast-1a"
  cidr_block = "10.40.32.0/20"
  map_public_ip_on_launch = true
  tags = {
    Name     = "taa-subnet-priv-2"
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

#resource "aws_eip" "taa_eip" {
#  vpc  = true
#  tags = {
#    Name     = "taa-nat-eip"
#    Resource = "taa"
#  }
#}

#resource "aws_nat_gateway" "taa_ngw" {
#  allocation_id = aws_eip.taa_eip.id
#  subnet_id     = aws_subnet.taa_sub_pub.id
#  tags = {
#    Name     = "taa-ngw"
#    Resource = "taa"
#  }
#}

resource "aws_route_table" "taa_main" {
  vpc_id = aws_vpc.taa.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.taa.id
  }
  tags = {
    Name     = "taa-routing-table-main"
    Resource = "taa"
  }
}

resource "aws_route_table" "taa_sub" {
  vpc_id = aws_vpc.taa.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.taa.id
  }
  tags = {
    Name     = "taa-routing-table-sub"
    Resource = "taa"
  }
}

resource "aws_route_table_association" "taa_pub" {
  subnet_id      = aws_subnet.taa_sub_pub.id
  route_table_id = aws_route_table.taa_main.id
}

resource "aws_route_table_association" "taa_priv1" {
  subnet_id      = aws_subnet.taa_sub_priv1.id
  route_table_id = aws_route_table.taa_sub.id
}

resource "aws_route_table_association" "taa_priv2" {
  subnet_id      = aws_subnet.taa_sub_priv2.id
  route_table_id = aws_route_table.taa_sub.id
}
