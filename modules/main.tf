# PROVIDER
# Points to AWS as cloud provider - DO NOT MODIFY THE PROVIDER. This template is designed to work ONLY with AWS.
# Region may be changed as needed. Template is NOT multi-regional.
provider "aws" {
  region = "us-east-1"
}

# MODULE
# Source resources are all in root directory, one level down in the file structure.
module "ftd_vpc" {
  source = "../"

  # This name will be attached at the front of all created resources for easy identification.
  name = "ftd-example"

  # CIDR block for VPC. Must be at least /24
  # 10.0.0.0/8 is reserved for EC2 classic.
  cidr = "10.0.1.0/24"

  # Mark as true to create and Internet Gateway for public traffic.
  # Set to false if deploying for a purely internal environment.
  enable_internet_gateway = true

  # Availability Zones must be within a single region.
  azs = [
    "us-east-1a",
    "us-east-1b"]

  # Subnets must be contained within VPC CIDR block and cannot overlap each other.
  # Each subnet type must have as many ranges as there are provided AZs.
  # If two AZs are provided, then each block must contain two ranges - and so on.
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

  # VPC flow log options.
  # DO NOT MODIFY unless you have a specific reason for doing so. Leave as-is in most situations.
  enable_flow_log = true
  create_flow_log_cloudwatch_log_group = true
  create_flow_log_cloudwatch_iam_role = true
  flow_log_max_aggregation_interval = 60

  # FTD EC2 options.
  # Set instance_count to the number of FTD you want to deploy.
  # The number much match the number of AZs that were provided.
  # A standard highly-available (HA) setup should deploy two.
  # Dev environments or Non-critical production workloads could safely use one.
  # Workloads in need of extreme HA should use four AZs and four FTDs.
  instance_count = 2

  # Input AMI for desired version of Cisco NGFW.
  # AMI can be found in AWS Marketplace in the Cisco NGFW listing.
  # Alternatively, you can create your own NGFW AMI and use that.
  cisco_ftd_ami = "ami-0efa191313698c95c"

  # There are a set number of instance types that can be used with the FTD.
  # Go the AWS Marketplace and select Launch, the advance through wizard until you reach
  # "Choose an Instance Type" to see the list of available types.
  # For most use cases, I recommend "c5.xlarge" for a mix of performance and value.
  # More traffic-intensive workloads will require more sophisticated instance types.
  instance_type = "c5.xlarge"

  # This attribute determines whether or not the FTD gets a public IP automatically.
  # If you want to deploy FTD without public IP (for use in an internal environment), set to false.
  associate_public_ip_address = true

  # Below settings for FTD storage are based on Cisco recommendations.
  # These should not need to change under most circumstances.
  volume_size = "52"
  volume_type = "gp2"

  # Name for the security group which will apply to the FTD.
  sg_name = "allow-ftd"

  # Name to append to the end of the secret in Secrets Manager holding the FTD TLS key.
  # My preference is to add the date and time of template deployment, but you can use whatever you want.
  secret_name = "test-key-9"
}

