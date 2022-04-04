provider "aws" {
  region = "us-east-1"
}

module "ftd_vpc" {
  source = "../"

  name = "ftd-example"

  cidr = "10.0.0.0/16"
  instance_tenancy = "default"
  azs = [
    "us-east-1a",
    "us-east-1b"]
  inside_subnets = [
    "10.0.1.0/28",
    "10.0.1.16/28"]
  outside_subnets = [
    "10.0.1.32/28",
    "10.0.1.48/28"]
  mgmt_subnets = [
    "10.0.1.64/28",
    "10.0.1.80/28"]
  diag_subnets = [
    "10.0.1.96/28",
    "10.0.1.112/28"
  ]

  enable_flow_log = true
  create_flow_log_cloudwatch_log_group = true
  create_flow_log_cloudwatch_iam_role = true
  flow_log_max_aggregation_interval = 60

  instance_count = 2
  cisco_ftd_ami = "ami-0efa191313698c95c"
  instance_type = "c5.xlarge"
  associate_public_ip_address = false
  volume_size = "52"
  volume_type = "gp2"
  admin_password = "2-sAD-sACK"
  host_name = "aws_ftd"

  sg_name = "allow-ftd"

  secret_name = "date_time"
}

