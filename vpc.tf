# VPC
# CIDR block is input in the module.
# Instance Tenancy is set to default as a require per Cisco documentation.
resource "aws_vpc" "vpc" {
  cidr_block = var.cidr
  instance_tenancy = "default"

  tags = {
    Name = var.name
  }
}

# INTERNET GATEWAY
# This allows the VPC and FTD to intake public internet traffic.
# Creation is controlled by variable in module
resource "aws_internet_gateway" "inet_gwy" {
  count = var.enable_internet_gateway ? 1 : 0
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = var.name
  }
}

# NAT GATEWAY
# This allows resources in a private subnet to reach public internet without exposing IP
resource "aws_nat_gateway" "nat_gwy" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id = aws_subnet.nat_gwy_subnet.id

  tags = {
    Name = "${var.name}"
  }
}

resource "aws_eip" "nat_eip" {

  tags = {
    Name = "${var.name}-nat-gwy"
  }
}