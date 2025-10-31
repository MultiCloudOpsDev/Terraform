#create vpc
resource "aws_vpc" "name" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name ="cust-vpc"
  }
}
#create subnets
resource "aws_subnet" "name" {
  vpc_id = aws_vpc.name.id
  cidr_block = "10.0.0.0/24"
  availability_zone = "us-east-1a"
  tags = {
    Name ="subnet-1-public"
  }
}
resource "aws_subnet" "name-2" {
  vpc_id = aws_vpc.name.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-east-1a"
  tags = {
    Name ="subnet-2-private"
  }
}
#create IG and attach to vpc
resource "aws_internet_gateway" "aws-ig" {
  tags = {
    Name ="cust-ig"
  }
  vpc_id = aws_vpc.name.id
}
#create route table and edit routes
resource "aws_route_table" "name" {
  vpc_id = aws_vpc.name.id
  tags = {
    Name="cust-rt-public"
  }
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.aws-ig.id
  }
}
#create route table public subnet associations
resource "aws_route_table_association" "name" {
  subnet_id = aws_subnet.name.id
  route_table_id = aws_route_table.name.id
}
#create sg
resource "aws_security_group" "aws-sg" {
  description = "allow"
  vpc_id = aws_vpc.name.id
  tags = {
    Name="test-sg"
  }
  ingress {
    description = "SSH"
    from_port = 22
    to_port = 22
    protocol = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "HTTP"
    from_port = 80
    to_port = 80
    protocol = "TCP"
    cidr_blocks = [ "0.0.0.0/0" ]
  }
  ingress {
    description = "HTTPS"
    from_port = 443
    to_port = 443
    protocol = "TCP"
    cidr_blocks = [ "0.0.0.0/0" ]
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"   # Represents all protocols
    cidr_blocks = ["0.0.0.0/0"]
  }
}
#create EIP
resource "aws_eip" "name" {
  domain = "vpc"        # vpc = true
  tags = {
    Name ="nat-eip"
  }
}
#create nat gateway
resource "aws_nat_gateway" "name" {
  subnet_id = aws_subnet.name.id
  allocation_id = aws_eip.name.id
  tags = {
    Name="cust-nat"
  }
}
#create route table and edit routes
resource "aws_route_table" "name-2" {
  vpc_id = aws_vpc.name.id
  tags = {
    Name="cust-rt-private"
  }
  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.name.id
  }
}
#create route table private associations
resource "aws_route_table_association" "name-2" {
  subnet_id = aws_subnet.name-2.id
  route_table_id = aws_route_table.name-2.id
}
#create servers
resource "aws_instance" "public" {
  ami =var.ami_id
  instance_type =var.instance_type
  subnet_id = aws_subnet.name.id
  vpc_security_group_ids = [ aws_security_group.aws-sg.id ]
  associate_public_ip_address = true
  tags = {
    Name="public-server"
  }
}
resource "aws_instance" "private" {
  ami = var.ami_id
  instance_type = var.instance_type
  subnet_id = aws_subnet.name-2.id
  vpc_security_group_ids = [ aws_security_group.aws-sg.id ]
  tags = {
    Name="private-server"
  }
}