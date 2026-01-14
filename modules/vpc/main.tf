# VPC module - main.tf
# Add VPC resources here
provider "aws" {
    region = var.region
  
}

resource "aws_vpc" "main" {
    cidr_block = var.vpc_cidr
    tags = {
        Name = var.vpc_name
    }
}

data "aws_availability_zones" "available" {
  state = "available"
}


resource "aws_subnet" "public_subnet" {
    count = length(data.aws_availability_zones.available.names)
    vpc_id = aws_vpc.main.id
    cidr_block = cidrsubnet(var.vpc_cidr, 8, count.index)
    availability_zone = data.aws_availability_zones.available.names[count.index]
    map_public_ip_on_launch = true
    
  tags = {
    Name = "${var.vpc_name}-public-${count.index + 1}"
  }

  
}

resource "aws_internet_gateway" "my-igw" {
    vpc_id = aws_vpc.main.id
    tags = {
        Name = "${var.vpc_name}-igw"
    }
  
}

resource "aws_route_table" "public_rt" {
    vpc_id = aws_vpc.main.id
    tags = {
        Name = "${var.vpc_name}-public-rt"
    }
  
}

resource "aws_route" "default_route" {
    route_table_id = aws_route_table.public_rt.id
    destination_cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my-igw.id
}
resource "aws_route_table_association" "public_rt_assoc" {
    count = length(aws_subnet.public_subnet)
    subnet_id = aws_subnet.public_subnet[count.index].id
    route_table_id = aws_route_table.public_rt.id
}

resource "aws_subnet" "private_subnet" {
    count = length(data.aws_availability_zones.available.names)
    vpc_id = aws_vpc.main.id
    cidr_block = cidrsubnet(var.vpc_cidr, 8, count.index + length(data.aws_availability_zones.available.names))
    availability_zone = data.aws_availability_zones.available.names[count.index]
    map_public_ip_on_launch = false
    
  tags = {
    Name = "${var.vpc_name}-private-${count.index + 1}"
  }
  
}

resource "aws_route_table" "private_rt" {
    vpc_id = aws_vpc.main.id
    tags = {
        Name = "${var.vpc_name}-private-rt"
    }
}

resource "aws_route" "private_route" {
    route_table_id = aws_route_table.private_rt.id
    destination_cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gw.id
}

resource "aws_nat_gateway" "nat_gw" {
    allocation_id = aws_eip.nat_eip.id
    subnet_id = aws_subnet.public_subnet[0].id
    tags = {
        Name = "${var.vpc_name}-nat-gw"
    }
  
}
resource "aws_eip" "nat_eip" {
    vpc = true
    tags = {
        Name = "${var.vpc_name}-nat-eip"
    }
  
}
resource "aws_route_table_association" "private_rt_assoc" {
    count = length(aws_subnet.private_subnet)
    subnet_id = aws_subnet.private_subnet[count.index].id
    route_table_id = aws_route_table.private_rt.id
}
