resource "aws_vpc" "name" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name ="cust-vpc"
  }
}
resource "aws_s3_bucket" "name" {
  bucket = "mybuckettargetresoucres"
}
resource "aws_instance" "name" {
  ami = "ami-07860a2d7eb515d9a"
  instance_type = "t3.micro"
  tags = {
    Name ="server"
  }
}
resource "aws_subnet" "name" {
  vpc_id = aws_vpc.name.id
  cidr_block = "10.0.0.0/24"
  tags = {
    Name="subnet-1"
  }
}


# The -target option is used to apply, plan, or destroy specific resources only below cmmds refreence
# terraform apply -target=aws_vpc.name

# You can also specify multiple resources using multiple -target options
# terraform plan -target=aws_instance.name -target=aws_s3_bucket.name



