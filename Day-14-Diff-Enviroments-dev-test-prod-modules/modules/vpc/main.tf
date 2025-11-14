resource "aws_vpc" "name" {
  cidr_block =var.cidr_block
  enable_dns_support = true
  enable_dns_hostnames = true
  tags = {
    Name ="${var.tags}-vpc"
  }
}

resource "aws_subnet" "name" {
  vpc_id = aws_vpc.name.id
  cidr_block =var.subnet_cidr
  tags = {
    Name ="${var.tags}-subnet"
  }
  availability_zone =var.az 
}