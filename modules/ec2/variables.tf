# EC2 module - variables.tf
# Declare input variables for the EC2 module
variable "name_prefix" {
  description = "Prefix used to name EC2 resources (instances, security group)"
  type        = string
}

variable "vpc_id" {
  description = "ID of the VPC to launch instances and the security group into (from the vpc module)"
  type        = string
}

variable "subnet_ids" {
  description = "Subnet IDs available for placement (from the vpc module, e.g. module.vpc.private_subnet_ids). Instances without an explicit subnet_id are distributed across these round-robin."
  type        = list(string)
}

variable "instances" {
  description = "Map of EC2 instances to create, keyed by a logical name (e.g. \"web-1\"). Per-instance fields override the module-level defaults below."
  type = map(object({
    instance_type = optional(string)
    subnet_id     = optional(string)
    tags          = optional(map(string), {})
  }))
}

variable "ami_id" {
  description = "AMI ID to use. If null, the latest Amazon Linux 2023 x86_64 AMI is looked up automatically."
  type        = string
  default     = "ami-0d351f1b760a30161"
}

variable "instance_type" {
  description = "Default instance type used when an entry in var.instances doesn't set its own"
  type        = string
  default     = "t3.micro"
}

variable "key_name" {
  description = "EC2 key pair name for SSH access. Leave null to launch without a key pair (e.g. SSM-only access)."
  type        = string
  default     = null
}

variable "associate_public_ip" {
  description = "Whether to assign a public IP to instances. Should be false for instances in private subnets."
  type        = bool
  default     = false
}

variable "root_volume_size" {
  description = "Root EBS volume size in GB"
  type        = number
  default     = 20
}

variable "root_volume_type" {
  description = "Root EBS volume type"
  type        = string
  default     = "gp3"
}

variable "iam_instance_profile" {
  description = "Name of an IAM instance profile to attach (e.g. output from the iam module). Leave null for none."
  type        = string
  default     = null
}

variable "additional_security_group_ids" {
  description = "Extra security group IDs to attach in addition to the one this module creates"
  type        = list(string)
  default     = []
}

variable "ingress_rules" {
  description = "Ingress rules for the instance security group"
  type = list(object({
    description = string
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
  default = []
}

variable "tags" {
  description = "Common tags applied to all resources created by this module"
  type        = map(string)
  default     = {}
}