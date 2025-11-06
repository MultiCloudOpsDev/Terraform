#Create a key pair using your public key
resource "aws_key_pair" "my_key" {
  key_name   = "my-key"                        # name shown in AWS
  public_key = file("~/.ssh/id_ed25519.pub")       # path to your local public key
}

#Create an EC2 instance using the key pair
resource "aws_instance" "web" {
  ami           =var.ami     
  instance_type =var.instance_type
  key_name      = aws_key_pair.my_key.key_name  # link key pair here
  availability_zone = "us-east-1a"
  tags = {
    Name = "terraform-ec2"
  }
}
