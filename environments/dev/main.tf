# Dev environment - main.tf
# Root configuration for the dev environment
module "vpc" {
  source   = "../../modules/vpc"
  region   = "us-west-2"
  vpc_cidr = "10.0.0.0/16"
  vpc_name = "dev-vpc"
}

