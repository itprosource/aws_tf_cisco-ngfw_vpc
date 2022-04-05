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
resource "aws_internet_gateway" "inet_gwy" {
  count = var.enable_internet_gateway ? 1 : 0
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = var.name
  }
}