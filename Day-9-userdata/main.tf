
resource "aws_instance" "web" {
  ami           =var.ami     
  instance_type =var.instance_type
  availability_zone = "us-east-1a"
  user_data = file("userdata.sh")   ## Calling userdata.sh from the same directory by using file function
  tags = {
    Name = "terraform-ec2"
  }
}