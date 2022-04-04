# Subnets

resource "aws_subnet" "outside" {
  count = length(var.outside_subnets)
  cidr_block = element(var.outside_subnets, count.index)
  vpc_id = aws_vpc.vpc.id
  availability_zone = element(var.azs, count.index)

  tags = {
    Name = "${var.name}-OUT-${count.index+1}"
  }
}

resource "aws_subnet" "inside" {
  count = length(var.inside_subnets)
  cidr_block = element(var.inside_subnets, count.index)
  vpc_id = aws_vpc.vpc.id
  availability_zone = element(var.azs, count.index)

  tags = {
    Name = "${var.name}-IN-${count.index+1}"
  }
}

resource "aws_subnet" "mgmt" {
  count = length(var.mgmt_subnets)
  cidr_block = element(var.mgmt_subnets, count.index)
  vpc_id = aws_vpc.vpc.id
  availability_zone = element(var.azs, count.index)

  tags = {
    Name = "${var.name}-MGMT-${count.index+1}"
  }
}

resource "aws_subnet" "diag" {
  count = length(var.diag_subnets)
  cidr_block = element(var.diag_subnets, count.index)
  vpc_id = aws_vpc.vpc.id
  availability_zone = element(var.azs, count.index)

  tags = {
    Name = "${var.name}-DIAG-${count.index+1}"
  }
}
