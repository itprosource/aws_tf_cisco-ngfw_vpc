# ROUTE TABLES
# These control the flow of traffic in your VPC.
# DO NOT MODIFY unless you know what you're doing and have a specific reason.
# You might modify these if you utilize certain VPC endpoints or other gateways.

# untrusted Route Table
# Includes an additional route which allows for traffic to and from the internet gateway.
# If used for an internal environment with no internet gateway, you may need to add your own
# route to whatever is being utilized for untrusted access - VPN gateway, transit gateway, etc.
# Nothing for that is included here, but you can easily build your own route in the TF template.
resource "aws_route_table" "untrusted" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "${var.name}-untrusted"
  }
}

# This route will not be created if enable_internet_gateway is set to false
resource "aws_route" "inet_gwy" {
  count = var.enable_internet_gateway ? 1 : 0
  route_table_id = aws_route_table.untrusted.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.inet_gwy[0].id
}

resource "aws_route_table_association" "untrusted" {
  count = length(var.untrusted_subnets)
  subnet_id = element(aws_subnet.untrusted.*.id,count.index)
  route_table_id = element(aws_route_table.untrusted.*.id,count.index)
}

# trusted Route Table
# Includes a route pointing to the trusted network interface on the FTD
resource "aws_route_table" "trusted" {
  count = var.instance_count
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "${var.name}-trusted-${count.index+1}"
  }
}

resource "aws_route" "trusted_eni" {
  count = var.instance_count
  destination_cidr_block = "0.0.0.0/0"
  route_table_id = element(aws_route_table.trusted.*.id,count.index)
  network_interface_id = element(aws_network_interface.trusted.*.id,count.index)
}

resource "aws_route_table_association" "trusted_association" {
  count = length(var.trusted_subnets)
  subnet_id = element(aws_subnet.trusted.*.id,count.index)
  route_table_id = element(aws_route_table.trusted.*.id,count.index)
}

# Mgmt Route Table
# Includes a route pointing to the management network interface on the FTD
resource "aws_route_table" "mgmt" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "${var.name}-mgmt"
  }
}

resource "aws_route" "nat_gwy" {
  destination_cidr_block = "0.0.0.0/0"
  route_table_id = aws_route_table.mgmt.id
  nat_gateway_id = aws_nat_gateway.nat_gwy.id
}

resource "aws_route_table_association" "mgmt_association" {
  count = var.instance_count
  subnet_id = element(aws_subnet.mgmt.*.id,count.index)
  route_table_id = aws_route_table.mgmt.id
}

# Diagnostic Route Table
# Includes a route pointing to the diagnostic network interface on the FTD
resource "aws_route_table" "diag" {
  count = var.instance_count
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "${var.name}-diag-${count.index+1}"
  }
}

resource "aws_route_table_association" "diag_association" {
  count = length(var.diag_subnets)
  subnet_id = element(aws_subnet.diag.*.id,count.index)
  route_table_id = element(aws_route_table.diag.*.id,count.index)
}
