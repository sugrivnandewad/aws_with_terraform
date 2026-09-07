aws_region              = "ap-south-1"
vpc_cidr                = "10.167.0.0/16"
vpc_name                = "dev-vpc"
az_count                = 2
enable_nat_gateway      = true
single_nat_gateway      = true
map_public_ip_on_launch = true

tags = {
  Environment = "dev"
  ManagedBy   = "terraform"
}
