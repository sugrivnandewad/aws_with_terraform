# Prod environment - main.tf
# Root configuration for the prod environment
module "vpc" {
  source   = "../../modules/vpc"
  region   = "ap-south-1"
  vpc_cidr = "10.168.0.0/16"
  vpc_name = "prod-vpc"
}