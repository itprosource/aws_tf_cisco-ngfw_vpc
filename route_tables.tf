## Outside Subnets

resource "aws_route_table" "outside" {
  vpc_id = aws_vpc.vpc.id

   route {
     cidr_block = "10.0.0.0/8"
     transit_gateway_id = var.transit_gwy_id
   }

  tags = {
    Name = "${var.name}-outside"
  }
}

resource "aws_route_table_association" "outside" {
  count = length(var.outside_subnets)
  subnet_id = element(aws_subnet.outside.*.id,count.index)
  route_table_id = element(aws_route_table.outside.*.id,count.index)
}

## Inside Subnets
resource "aws_route_table" "inside" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "${var.name}-inside"
  }
}

resource "aws_route_table_association" "inside_association" {
  count = length(var.inside_subnets)
  subnet_id = element(aws_subnet.inside.*.id,count.index)
  route_table_id = element(aws_route_table.inside.*.id,count.index)
}

## Mgmt Subnets
resource "aws_route_table" "mgmt" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "10.0.0.0/8"
    transit_gateway_id = var.transit_gwy_id
  }

  tags = {
    Name = "${var.name}-mgmt"
  }
}

resource "aws_route_table_association" "mgmt_association" {
  count = length(var.mgmt_subnets)
  subnet_id = element(aws_subnet.mgmt.*.id,count.index)
  route_table_id = element(aws_route_table.mgmt.*.id,count.index)
}

## Diag Subnets
resource "aws_route_table" "diag" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "${var.name}-diag"
  }
}

resource "aws_route_table_association" "diag_association" {
  count = length(var.diag_subnets)
  subnet_id = element(aws_subnet.diag.*.id,count.index)
  route_table_id = element(aws_route_table.mgmt.*.id,count.index)
}
