module "vpc" {
  source = "../../modules/vpc"

  vpc_cidr                = var.vpc_cidr
  vpc_name                = var.vpc_name
  az_count                = var.az_count
  enable_nat_gateway      = var.enable_nat_gateway
  single_nat_gateway      = var.single_nat_gateway
  map_public_ip_on_launch = var.map_public_ip_on_launch
  tags                    = var.tags
}

module "ec2" {
  source = "../../modules/ec2"

  name_prefix = "${var.vpc_name}-ec2"
  vpc_id      = module.vpc.vpc_id
  subnet_ids  = module.vpc.private_subnet_ids

  instances = {
    app = {}
  }

  tags = var.tags
}
