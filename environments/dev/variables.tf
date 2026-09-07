variable "aws_region" {
  description = "AWS region for the dev environment"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for the dev VPC"
  type        = string
}

variable "vpc_name" {
  description = "Name of the dev VPC"
  type        = string
}

variable "az_count" {
  description = "Number of availability zones to use"
  type        = number
}

variable "enable_nat_gateway" {
  description = "Create NAT Gateway(s) for private subnet outbound access"
  type        = bool
}

variable "single_nat_gateway" {
  description = "Use a single NAT Gateway instead of one per AZ"
  type        = bool
}

variable "map_public_ip_on_launch" {
  description = "Auto-assign public IPs in public subnets"
  type        = bool
}

variable "tags" {
  description = "Common tags for the environment"
  type        = map(string)
  default     = {}
}
