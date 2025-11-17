resource "aws_vpc" "name" {
   cidr_block = "10.0.0.0/16"  
   tags = {
     Name = "cust-vpc"
   }
}

resource "aws_subnet" "name" {
  vpc_id = aws_vpc.name.id
  cidr_block = "10.0.0.0/24"
  tags = {
    Name="subnet-1"
  }
  availability_zone = "us-east-1a"
}

resource "aws_instance" "name" {
  ami = var.ami_id
  instance_type = var.instance_type
  subnet_id = aws_subnet.name.id
  tags = {
    Name ="terraform server"
  }
}