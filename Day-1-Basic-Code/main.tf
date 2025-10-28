resource "aws_vpc" "name" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name ="cust-vpc"
  }
}

resource "aws_vpc" "name1" {
  cidr_block = "10.1.0.0/16"
  tags = {
    Name="project-vpc"
  }
}

resource "aws_subnet" "name" {
  vpc_id = aws_vpc.name.id
  cidr_block = "10.0.0.0/24"
  tags = {
    Name ="subnet-1"
  }
}

resource "aws_subnet" "name1" {
  vpc_id = aws_vpc.name.id
  cidr_block = "10.0.1.0/24"
  tags = {
    Name ="subnet-2"
  }
}

resource "aws_internet_gateway" "name" {
  tags = {
    Name ="cust-ig"
  }
}