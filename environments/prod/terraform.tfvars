aws_region              = "ap-south-1"
vpc_cidr                = "10.168.0.0/16"
vpc_name                = "prod-vpc"
az_count                = 3
enable_nat_gateway      = true
single_nat_gateway      = false
map_public_ip_on_launch = true

tags = {
  Environment = "prod"
  ManagedBy   = "terraform"
}
