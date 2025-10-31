resource "aws_instance" "name" {
  ami = "ami-0360c520857e3138f"
  instance_type = "t3.micro"
  tags = {
    Name="server"
  }

  #lifecycle {
  #  ignore_changes = [ tags,instance_type ]
  #}
  #lifecycle {
  # prevent_destroy = true
  #}
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_vpc" "name" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name ="cust-vpc"
  }

  lifecycle {
    ignore_changes = [ tags, ]
  }
}

