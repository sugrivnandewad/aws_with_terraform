# Dev environment - main.tf
# Root configuration for the dev environment
module "vpc" {
  source   = "../../modules/vpc"
  region   = "ap-south-1"
  vpc_cidr = "10.167.0.0/16"
  vpc_name = "dev-vpc"
}

