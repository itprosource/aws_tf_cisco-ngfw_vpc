# ROUTE TABLES
# These control the flow of traffic in your VPC.
# DO NOT MODIFY unless you know what you're doing and have a specific reason.
# You might modify these if you utilize certain VPC endpoints or other gateways.

# Outside Route Table
# Includes an additional route which allows for traffic to and from the internet gateway.
# If used for an internal environment with no internet gateway, you may need to add your own
# route to whatever is being utilized for outside access - VPN gateway, transit gateway, etc.
# Nothing for that is included here, but you can easily build your own route in the TF template.
resource "aws_route_table" "outside" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "${var.name}-outside"
  }
}

# This route will not be created if enable_internet_gateway is set to false
resource "aws_route" "inet_gwy" {
  count = var.enable_internet_gateway ? 1 : 0
  route_table_id = aws_route_table.outside.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.inet_gwy[0].id
}

resource "aws_route_table_association" "outside" {
  count = length(var.outside_subnets)
  subnet_id = element(aws_subnet.outside.*.id,count.index)
  route_table_id = element(aws_route_table.outside.*.id,count.index)
}

# Inside Route Table
# Includes a route pointing to the inside network interface on the FTD
resource "aws_route_table" "inside" {
  count = var.instance_count
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "${var.name}-inside-${count.index+1}"
  }
}

resource "aws_route" "inside_eni" {
  count = var.instance_count
  route_table_id = element(aws_route_table.inside.*.id,count.index)
  destination_cidr_block = "0.0.0.0/0"
  network_interface_id = element(aws_network_interface.inside.*.id,count.index)
}

resource "aws_route_table_association" "inside_association" {
  count = length(var.inside_subnets)
  subnet_id = element(aws_subnet.inside.*.id,count.index)
  route_table_id = element(aws_route_table.inside.*.id,count.index)
}

# Mgmt Route Table
# Includes a route pointing to the management network interface on the FTD
resource "aws_route_table" "mgmt" {
  count = var.instance_count
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "${var.name}-mgmt-${count.index+1}"
  }
}

resource "aws_route" "mgmt_eni" {
  count = var.instance_count
  route_table_id = element(aws_route_table.mgmt.*.id,count.index)
  destination_cidr_block = "0.0.0.0/0"
  network_interface_id = element(aws_instance.ftd[*].primary_network_interface_id,count.index)
}



resource "aws_route_table_association" "mgmt_association" {
  count = length(var.mgmt_subnets)
  subnet_id = element(aws_subnet.mgmt.*.id,count.index)
  route_table_id = element(aws_route_table.mgmt.*.id,count.index)
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

resource "aws_route" "diag_eni" {
  count = var.instance_count
  route_table_id = element(aws_route_table.diag.*.id,count.index)
  destination_cidr_block = "0.0.0.0/0"
  network_interface_id = element(aws_network_interface.diag.*.id,count.index)
}

resource "aws_route_table_association" "diag_association" {
  count = length(var.diag_subnets)
  subnet_id = element(aws_subnet.diag.*.id,count.index)
  route_table_id = element(aws_route_table.diag.*.id,count.index)
}
