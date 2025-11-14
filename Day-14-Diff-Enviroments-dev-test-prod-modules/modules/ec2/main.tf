resource "aws_instance" "name" {
  ami =var.ami
  instance_type =var.instance_type
  tags = {
    Name ="${var.tags}-ec2"
  }
  availability_zone = var.az
  subnet_id = var.subnet_id
}