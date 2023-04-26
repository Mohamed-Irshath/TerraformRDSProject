resource "aws_vpc" "DB-VPC" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = "true"
}

resource "aws_subnet" "PublicSubnet" {
  vpc_id                  = aws_vpc.DB-VPC.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = "true"
  availability_zone       = "us-east-1a"
  depends_on = [
    aws_vpc.DB-VPC
  ]
}

resource "aws_subnet" "PrivateSubnet" {
  vpc_id            = aws_vpc.DB-VPC.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-east-1a"
  depends_on = [
    aws_vpc.DB-VPC
  ]
}

resource "aws_subnet" "PrivateSubnet2" {
  vpc_id            = aws_vpc.DB-VPC.id
  cidr_block        = "10.0.3.0/24"
  availability_zone = "us-east-1b"
  depends_on = [
    aws_vpc.DB-VPC
  ]
}

resource "aws_internet_gateway" "DB-VPC-IGW" {
}

resource "aws_internet_gateway_attachment" "DB-VPC-IGW-ATTACHMENT" {
  vpc_id              = aws_vpc.DB-VPC.id
  internet_gateway_id = aws_internet_gateway.DB-VPC-IGW.id
  depends_on = [
    aws_internet_gateway.DB-VPC-IGW
  ]
}

resource "aws_route_table" "PublicRouteTable" {
  vpc_id = aws_vpc.DB-VPC.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.DB-VPC-IGW.id
  }
}

resource "aws_route_table" "PrivateRouteTable" {
  vpc_id = aws_vpc.DB-VPC.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.PublicNAT4PrivateSubnet.id
  }
  depends_on = [
    aws_nat_gateway.PublicNAT4PrivateSubnet
  ]
}

resource "aws_route_table" "PrivateRouteTable2" {
  vpc_id = aws_vpc.DB-VPC.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.PublicNAT4PrivateSubnet.id
  }
  depends_on = [
    aws_nat_gateway.PublicNAT4PrivateSubnet
  ]
}

resource "aws_route_table_association" "PublicRouteTableAsso" {
  subnet_id      = aws_subnet.PublicSubnet.id
  route_table_id = aws_route_table.PublicRouteTable.id
}

resource "aws_route_table_association" "PrivateRouteTableAsso" {
  subnet_id      = aws_subnet.PrivateSubnet.id
  route_table_id = aws_route_table.PrivateRouteTable.id
}

resource "aws_route_table_association" "PrivateRouteTableAsso2" {
  subnet_id      = aws_subnet.PrivateSubnet2.id
  route_table_id = aws_route_table.PrivateRouteTable2.id
}

resource "aws_eip" "ElasticIP4NAT" {
  depends_on = [
    aws_internet_gateway.DB-VPC-IGW
  ]
}

resource "aws_nat_gateway" "PublicNAT4PrivateSubnet" {
  allocation_id = aws_eip.ElasticIP4NAT.id
  subnet_id     = aws_subnet.PublicSubnet.id
  depends_on = [
    aws_eip.ElasticIP4NAT
  ]
}