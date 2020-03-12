# --------------- VPC ---------------
resource "aws_vpc" "taa" {
  cidr_block           = var.cidr_block
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name     = "taa-vpc"
    Resource = "taa"
  }
}

# --------------- SubNet ---------------
resource "aws_subnet" "taa_sub_pub1" {
  vpc_id = aws_vpc.taa.id
  availability_zone = var.az["az1"]
  cidr_block = var.subnet_cidr_block["pub1"]
  map_public_ip_on_launch = true
  tags = {
    Name     = "taa-subnet-pub-1"
    Resource = "taa"
  }
}

resource "aws_subnet" "taa_sub_pub2" {
  vpc_id = aws_vpc.taa.id
  availability_zone = var.az["az2"]
  cidr_block = var.subnet_cidr_block["pub2"]
  map_public_ip_on_launch = true
  tags = {
    Name     = "taa-subnet-pub-2"
    Resource = "taa"
  }
}

resource "aws_subnet" "taa_sub_priv1" {
  vpc_id = aws_vpc.taa.id
  availability_zone = var.az["az1"]
  cidr_block = var.subnet_cidr_block["pri1"]
  map_public_ip_on_launch = true
  tags = {
    Name     = "taa-subnet-priv-1"
    Resource = "taa"
  }
}

resource "aws_subnet" "taa_sub_priv2" {
  vpc_id = aws_vpc.taa.id
  availability_zone = var.az["az2"]
  cidr_block = var.subnet_cidr_block["pri2"]
  map_public_ip_on_launch = true
  tags = {
    Name     = "taa-subnet-priv-2"
    Resource = "taa"
  }
}

# --------------- Gateway ---------------
resource "aws_internet_gateway" "taa_igw" {
  vpc_id = aws_vpc.taa.id
  tags = {
    Name     = "taa-igw"
    Resource = "taa"
  }
}

resource "aws_eip" "taa_ngw_eip" {
  vpc  = true
  tags = {
    Name     = "taa-ngw-eip"
    Resource = "taa"
  }
}

resource "aws_nat_gateway" "taa_ngw" {
  allocation_id = aws_eip.taa_ngw_eip.id
  subnet_id     = aws_subnet.taa_sub_pub1.id
  tags = {
    Name     = "taa-ngw"
    Resource = "taa"
  }
}

# --------------- Routing Table ---------------
resource "aws_route_table" "taa_main" {
  vpc_id = aws_vpc.taa.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.taa_igw.id
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
    gateway_id = aws_nat_gateway.taa_ngw.id
  }
  tags = {
    Name     = "taa-routing-table-sub"
    Resource = "taa"
  }
}

resource "aws_route_table_association" "taa_pub1" {
  subnet_id      = aws_subnet.taa_sub_pub1.id
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
