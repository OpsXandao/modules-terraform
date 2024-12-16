terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  required_version = ">= 1.5.0"
}

provider "aws" {
  region = var.aws_region
}

resource "aws_vpc" "this" {
  cidr_block           = var.cidr_block
  instance_tenancy     = "default"
  enable_dns_hostnames = var.enable_dns_hostnames
  enable_dns_support   = var.enable_dns_support
  tags = {
    Name = var.name
  }
}

resource "aws_subnet" "public" {
  count = length(var.public_subnets)

  vpc_id                = aws_vpc.this.id
  cidr_block            = var.public_subnets[count.index]
  availability_zone     = element(var.azs, count.index)
  map_public_ip_on_launch = true
  tags = {
    Name = "${var.name}-public-${count.index + 1}"
  }
}

resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id

  tags = {
    Name = "${var.name}-igw"
  }
}

resource "aws_route_table" "public" {
    vpc_id = aws_vpc.this.id
    tags = {
      Name = "${var.name}-public-rt"
    }
}

resource "aws_route" "route_to_internet" {
  route_table_id = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.this.id
}

resource "aws_route_table_association" "public_subnets" {
  count = length(var.public_subnets)

  subnet_id = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

resource "aws_subnet" "private" {
  count = length(var.private_subnets)

  vpc_id = aws_vpc.this.id
  cidr_block = var.private_subnets[count.index]
  availability_zone = element(var.azs, count.index)
  tags = {
    Name = "${var.name}-private-${count.index + 1}"
  }
}

resource "aws_eip" "nat" {
  count = var.nat_gateway ? 1 : 0
  domain = "vpc"
  tags = {
    Name = "${var.name}-nat-eip"
  }
}


resource "aws_nat_gateway" "this" {
  count         = var.nat_gateway ? 1 : 0
  allocation_id = aws_eip.nat[0].id
  subnet_id     = aws_subnet.public[0].id
  tags = {
    Name = "${var.name}-nat-gw"
  }
}

# Private Route Table
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.this.id
  tags = {
    Name = "${var.name}-private-rt"
  }
}

# Private Route: Route through NAT Gateway
resource "aws_route" "nat_gateway" {
  count               = var.nat_gateway ? 1 : 0
  route_table_id      = aws_route_table.private.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id      = aws_nat_gateway.this[0].id
}

# Associate Private Subnets with Private Route Table
resource "aws_route_table_association" "private_subnets" {
  count = length(aws_subnet.private)

  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private.id
}
