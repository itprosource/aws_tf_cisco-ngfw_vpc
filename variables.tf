variable "name" {
  type = string
  description = ""
  default = ""
}

## VPC

variable "cidr" {
  type = string
  description = ""
  default = ""
}

variable "transit_gwy_id" {
  type = string
  description = ""
  default = ""
}

variable "enable_internet_gateway" {
  type = bool
  description = ""
  default = true
}

## SUBNETS

variable "inside_subnets" {
  type = list(string)
  description = ""
  default = []
}

variable "outside_subnets" {
  type = list(string)
  description = ""
  default = []
}

variable "mgmt_subnets" {
  type = list(string)
  description = ""
  default = []
}

variable "diag_subnets" {
  type = list(string)
  description = ""
  default = []
}

variable "azs" {
  type = list(string)
  description = ""
  default = []
}

variable "availability_zone_id" {
  type = list(string)
  description = ""
  default = []
}

## CUSTOMER GATEWAY

variable "customer_gateways" {
  description = "Maps of Customer Gateway's attributes (BGP ASN and Gateway's Internet-routable external IP address)"
  type        = map(map(any))
  default     = {}
}

## FLOW LOGS

variable "enable_flow_log" {
  description = "Whether or not to enable VPC Flow Logs"
  type        = bool
  default     = false
}

variable "create_flow_log_cloudwatch_log_group" {
  description = "Whether to create CloudWatch log group for VPC Flow Logs"
  type        = bool
  default     = false
}

variable "create_flow_log_cloudwatch_iam_role" {
  description = "Whether to create IAM role for VPC Flow Logs"
  type        = bool
  default     = false
}

variable "flow_log_traffic_type" {
  description = "The type of traffic to capture. Valid values: ACCEPT, REJECT, ALL."
  type        = string
  default     = "ALL"
}

variable "flow_log_destination_type" {
  description = "Type of flow log destination. Can be s3 or cloud-watch-logs."
  type        = string
  default     = "cloud-watch-logs"
}

variable "flow_log_log_format" {
  description = "The fields to include in the flow log record, in the order in which they should appear."
  type        = string
  default     = null
}

variable "flow_log_destination_arn" {
  description = "The ARN of the CloudWatch log group or S3 bucket where VPC Flow Logs will be pushed. If this ARN is a S3 bucket the appropriate permissions need to be set on that bucket's policy. When create_flow_log_cloudwatch_log_group is set to false this argument must be provided."
  type        = string
  default     = ""
}

variable "flow_log_cloudwatch_iam_role_arn" {
  description = "The ARN for the IAM role that's used to post flow logs to a CloudWatch Logs log group. When flow_log_destination_arn is set to ARN of Cloudwatch Logs, this argument needs to be provided."
  type        = string
  default     = ""
}

variable "flow_log_cloudwatch_log_group_name_prefix" {
  description = "Specifies the name prefix of CloudWatch Log Group for VPC flow logs."
  type        = string
  default     = "/aws/vpc-flow-log/"
}

variable "flow_log_cloudwatch_log_group_retention_in_days" {
  description = "Specifies the number of days you want to retain log events in the specified log group for VPC flow logs."
  type        = number
  default     = null
}

variable "flow_log_cloudwatch_log_group_kms_key_id" {
  description = "The ARN of the KMS Key to use when encrypting log data for VPC flow logs."
  type        = string
  default     = null
}

variable "flow_log_max_aggregation_interval" {
  description = "The maximum interval of time during which a flow of packets is captured and aggregated into a flow log record. Valid Values: `60` seconds or `600` seconds."
  type        = number
  default     = 600
}

variable "vpc_flow_log_tags" {
  description = "Additional tags for the VPC Flow Logs"
  type        = map(string)
  default     = {}
}

variable "vpc_flow_log_permissions_boundary" {
  description = "The ARN of the Permissions Boundary for the VPC Flow Log IAM Role"
  type        = string
  default     = null
}

variable "cisco_ftd_ami" {
  description = "AMI ID for Cisco NGFW Byol AMI."
  type = string
  default = ""
}

# FTD
variable "create_ftd" {
  description = ""
  type = bool
  default = true
}

variable "instance_type" {
  description = ""
  type = string
  default = ""
}

variable "associate_public_ip_address" {
  description = ""
  type = bool
  default = false
}

variable "volume_size" {
  description = ""
  type = string
  default = ""
}

variable "volume_type" {
  description = ""
  type = string
  default = ""
}

variable "sg_name" {
  description = ""
  type = string
  default = ""
}

variable "admin_password" {
  description = ""
  type = string
  default = ""
}

variable "host_name" {
  description = ""
  type = string
  default = ""
}

variable "instance_count" {
  description = ""
  type = number
  default = 1
}

variable "secret_name" {
  description = ""
  type = string
  default = ""
}