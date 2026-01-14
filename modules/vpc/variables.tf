# VPC module - variables.tf
# Declare input variables for the VPC module
region "vpc" {
  description = "The region where the VPC will be created"
  type        = string
  default     = "ap-south-1"
}
vpc_cidr "vpc" {
  description = "The CIDR block for the VPC"
  type        = string
  default     = "10.167.0.0/16"
}