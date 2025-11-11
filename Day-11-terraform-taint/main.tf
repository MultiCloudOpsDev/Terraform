# VPC
resource "aws_vpc" "myvpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "MyVPC"
  }
}

# Subnet
resource "aws_subnet" "sub1" {
  vpc_id                  = aws_vpc.myvpc.id
  cidr_block              = "10.0.0.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "PublicSubnet"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.myvpc.id
}

# Route Table
resource "aws_route_table" "RT" {
  vpc_id = aws_vpc.myvpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

# Associate Route Table
resource "aws_route_table_association" "rta1" {
  subnet_id      = aws_subnet.sub1.id
  route_table_id = aws_route_table.RT.id
}

# Security Group
resource "aws_security_group" "webSg" {
  name   = "web"
  vpc_id = aws_vpc.myvpc.id

  ingress {
    description = "Allow HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# EC2 Instance 
resource "aws_instance" "server" {
  ami                         = "ami-0cae6d6fe6048ca2c" 
  instance_type               = "t3.micro"
  key_name                    = "us-east-1"
  subnet_id                   = aws_subnet.sub1.id
  vpc_security_group_ids      = [aws_security_group.webSg.id]
  associate_public_ip_address = true

  tags = {
    Name = "Server"
  }
 }


resource "null_resource" "run_script" {
  provisioner "remote-exec" {
    connection {
      host        = aws_instance.server.public_ip
      user        = "ec2-user"
      private_key = file("C:/Users/RAJASHRI/Downloads/us-east-1.pem")
    }

    inline = [
      "echo 'hello from awsdevopsmulticloud-by-veera-nareshit-devops' >> /home/ec2-user/file200"
    ]
  }

#   triggers = {
#     always_run = "${timestamp()}" # Forces rerun every time
#   }
}

#re-running null_resource depend on timestamp not on content modification.. becuse state file is not tracking inside the content 


#Solution-2 to Re-Run the Provisioner
#Use terraform taint to manually mark the resource for recreation:
# terraform taint aws_instance.server
# terraform apply