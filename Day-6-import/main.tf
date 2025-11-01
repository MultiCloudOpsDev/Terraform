resource "aws_instance" "name" {
  ami = "ami-0bdd88bd06d16ba03"
  instance_type = "t3.micro"
  tags = {
    Name ="server"
  }
}
resource "aws_vpc" "name" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name="my-vpc"
  }
}



#terraform import is used to bring existing remote resources (like an EC2 instance, S3 bucket, etc.) into the Terraform state file (.tfstate) — without recreating them.

#steps:
#1)Create empty resource block in .tf
#2)Run terraform import command
#terraform import aws_instance.name <EC2 instance id>
#3)Terraform import only brings the resource state into Terraform — it does not automatically add configuration to main.tf file.

#4)Always run terraform plan after import to verify configuration matches the actual resource.

