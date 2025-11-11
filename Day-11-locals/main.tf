locals {
  instance_type = "t3.micro"
  ami           = "ami-0cae6d6fe6048ca2c"
  region = "us-west-2"
  bucket_name = "${var.layer}-${var.env}-bucket-shrii1111111"
}

resource "aws_s3_bucket" "demo" {
    bucket = local.bucket_name
    region = local.region
    tags = {
        Name = local.bucket_name
        Environment = var.env
    }    
}


resource "aws_instance" "example" {
  ami           = local.ami
  instance_type = local.instance_type
  tags = {
    Name = "App-${local.region}"
  }
}
resource "aws_instance" "example1" {
  ami           = local.ami
  instance_type = local.instance_type
  tags = {
    Name = "server"
  }
}