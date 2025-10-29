resource "aws_instance" "name" {
  ami =var.ami_id
  instance_type =var.instance_type
  tags = {
    Name ="server"
  }
}

resource "aws_s3_bucket" "name" {
  bucket = "mys3terraformbucket1"
}