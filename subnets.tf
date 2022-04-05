# SUBNETS
# The 'count' line creates as many subnets as CIDR ranges you provide in the module.
# The availability_zone line will create a subnet in each AZ specified in the module.
# You MUST specify multiple AZs in order to deploy multiples of the same subnet type.

# Outside subnet for untrusted traffic coming in from the internet.
resource "aws_subnet" "outside" {
  count = length(var.outside_subnets)
  cidr_block = element(var.outside_subnets, count.index)
  vpc_id = aws_vpc.vpc.id
  availability_zone = element(var.azs, count.index)

  tags = {
    Name = "${var.name}-OUT-${count.index+1}"
  }
}

# Inside subnet for trusted traffic from behind the firewall.
resource "aws_subnet" "inside" {
  count = length(var.inside_subnets)
  cidr_block = element(var.inside_subnets, count.index)
  vpc_id = aws_vpc.vpc.id
  availability_zone = element(var.azs, count.index)

  tags = {
    Name = "${var.name}-IN-${count.index+1}"
  }
}


# Management subnet used for accessing FTD management tools.
resource "aws_subnet" "mgmt" {
  count = length(var.mgmt_subnets)
  cidr_block = element(var.mgmt_subnets, count.index)
  vpc_id = aws_vpc.vpc.id
  availability_zone = element(var.azs, count.index)

  tags = {
    Name = "${var.name}-MGMT-${count.index+1}"
  }
}

# Diagnostic subnet - can be used for troubleshooting if the need arises.
resource "aws_subnet" "diag" {
  count = length(var.diag_subnets)
  cidr_block = element(var.diag_subnets, count.index)
  vpc_id = aws_vpc.vpc.id
  availability_zone = element(var.azs, count.index)

  tags = {
    Name = "${var.name}-DIAG-${count.index+1}"
  }
}