# VPC
resource "aws_vpc" "vpc" {
  cidr_block = var.cidr
  instance_tenancy = var.instance_tenancy

  tags = {
    Name = var.name
  }
}

# Transit Gateway Attachment
resource "aws_ec2_transit_gateway_vpc_attachment" "transit_attach" {
  subnet_ids = "${aws_subnet.outside.*.id}"
  transit_gateway_id = var.transit_gwy_id
  vpc_id = aws_vpc.vpc.id
}