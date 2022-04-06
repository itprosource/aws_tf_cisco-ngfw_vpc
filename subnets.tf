# SUBNETS
# The 'count' line creates as many subnets as CIDR ranges you provide in the module.
# The availability_zone line will create a subnet in each AZ specified in the module.
# You MUST specify multiple AZs in order to deploy multiples of the same subnet type.

# untrusted subnet for untrusted traffic coming in from the internet.
resource "aws_subnet" "untrusted" {
  count = length(var.untrusted_subnets)
  cidr_block = element(var.untrusted_subnets, count.index)
  vpc_id = aws_vpc.vpc.id
  availability_zone = element(var.azs, count.index)

  tags = {
    Name = "${var.name}-untrust-${count.index+1}"
  }
}

# trusted subnet for trusted traffic from behind the firewall.
resource "aws_subnet" "trusted" {
  count = length(var.trusted_subnets)
  cidr_block = element(var.trusted_subnets, count.index)
  vpc_id = aws_vpc.vpc.id
  availability_zone = element(var.azs, count.index)

  tags = {
    Name = "${var.name}-trust-${count.index+1}"
  }
}


# Management subnet used for accessing FTD management tools.
resource "aws_subnet" "mgmt" {
  count = length(var.mgmt_subnets)
  cidr_block = element(var.mgmt_subnets, count.index)
  vpc_id = aws_vpc.vpc.id
  availability_zone = element(var.azs, count.index)

  tags = {
    Name = "${var.name}-mgmt-${count.index+1}"
  }
}

# Diagnostic subnet - can be used for troubleshooting if the need arises.
resource "aws_subnet" "diag" {
  count = length(var.diag_subnets)
  cidr_block = element(var.diag_subnets, count.index)
  vpc_id = aws_vpc.vpc.id
  availability_zone = element(var.azs, count.index)

  tags = {
    Name = "${var.name}-diag-${count.index+1}"
  }
}

resource "aws_subnet" "nat_gwy_subnet" {
  cidr_block = var.nat_gwy_subnet
  vpc_id = aws_vpc.vpc.id
  availability_zone = var.azs[0]

  tags = {
    Name = "${var.name}-nat_gwy"
  }
}