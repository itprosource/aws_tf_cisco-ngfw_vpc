# FTD instance(s)
resource "aws_instance" "ftd" {
  count = var.instance_count
  ami = var.cisco_ftd_ami
  instance_type = var.instance_type
  availability_zone = element(var.azs, count.index)
  subnet_id = element(aws_subnet.mgmt.*.id,count.index)
  key_name = aws_key_pair.key_pair.id
  vpc_security_group_ids = [aws_security_group.sg.id]
  associate_public_ip_address = var.associate_public_ip_address

  ebs_block_device {
    device_name = "/dev/sda1"
    delete_on_termination = true
    volume_size = var.volume_size
    volume_type = var.volume_type
  }

  metadata_options {
    http_endpoint = "enabled"
    http_tokens = "required"
  }

  tags = {
    Name = "${var.name}-${count.index+1}"
  }
}

# ENIs
resource "aws_network_interface" "outside" {
  count = var.instance_count
  description = "${var.name}-out-${count.index+1}"
  subnet_id       = element(aws_subnet.outside.*.id,count.index)
  security_groups = [aws_security_group.sg.id]
  source_dest_check = false

  attachment {
    instance     = aws_instance.ftd[count.index].id
    device_index = 1
  }
}

resource "aws_network_interface" "inside" {
  count = var.instance_count
  description = "${var.name}-in-${count.index+1}"
  subnet_id       = element(aws_subnet.inside.*.id,count.index)
  security_groups = [aws_security_group.sg.id]
  source_dest_check = false

  attachment {
    instance     = aws_instance.ftd[count.index].id
    device_index = 2
  }
}
/*
resource "aws_network_interface" "mgmt" {
  count = var.create_ftd && var.instance_count > 0 ? 1 : 0
  description = "${var.name}-mgmt-${count.index+1}"
  subnet_id       = element(aws_subnet.mgmt.*.id,count.index)
  security_groups = [aws_security_group.sg.id]
  source_dest_check = false

  attachment {
    instance     = aws_instance.ftd[count.index].id
    device_index = 3
  }
}
*/

resource "aws_network_interface" "diag" {
  count = var.instance_count
  description = "${var.name}-diag-${count.index+1}"
  subnet_id       = element(aws_subnet.diag.*.id,count.index)
  security_groups = [aws_security_group.sg.id]
  source_dest_check = false

  attachment {
    instance     = aws_instance.ftd[count.index].id
    device_index = 3
  }
}


# FTD Security Group
resource "aws_security_group" "sg" {
  name = var.sg_name
  description = "A security group that allows inbound web traffic (TCP ports 80 and 443)."
  vpc_id = aws_vpc.vpc.id

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = [
      "0.0.0.0/0"
    ]
    description = "Allow HTTP traffic"
  }
  ingress {
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = [
      "0.0.0.0/0"
    ]
    description = "Allow HTTPS traffic"
  }
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = [
      "10.0.0.0/8",
      "172.20.64.64/28",
      "172.20.64.80/28"
    ]
    description = "Allow HTTP traffic"
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

}

# Key pair, stored in Secrets Manager
resource "tls_private_key" "key" {
  algorithm = "RSA"
}

resource "aws_key_pair" "key_pair" {
  key_name   = "${var.name}-key"
  public_key = tls_private_key.key.public_key_openssh
  tags = {
    Name = "${var.name}-key"
  }
}

resource "aws_secretsmanager_secret" "secret" {
  name = "${var.name}-${var.secret_name}"
}

resource "aws_secretsmanager_secret_version" "secret_version" {
  secret_id     = aws_secretsmanager_secret.secret.id
  secret_string = tls_private_key.key.private_key_pem
}