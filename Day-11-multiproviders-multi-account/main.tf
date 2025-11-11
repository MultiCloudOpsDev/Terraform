resource "aws_vpc" "name" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name="cust-vpc"
  }
}

resource "aws_vpc" "name1" {  
  cidr_block = "10.1.0.0/16"
  tags = {
    Name="myvpc"
  }
  provider = aws.west-2
}
resource "aws_vpc" "name2" {
  cidr_block = "10.2.0.0/16"
  tags = {
    Name="vpc"
  }
  provider = aws.west-1
}