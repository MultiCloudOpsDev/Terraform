resource "aws_instance" "name" {
  ami ="ami-0cae6d6fe6048ca2c"
  instance_type = "t3.micro"
  for_each = toset(var.tags)        # Creates one EC2 instance for each unique value in var.tags
  tags = {
    #Name ="dev"
    Name=each.value                 # Sets Name tag to the current item from var.tags
  }
}

resource "aws_s3_bucket" "name" {
   for_each = toset(var.bucket_name)      # Creates one S3 bucket for each name in var.bucket_name
   bucket =each.value                     # Sets bucket name to the current value
}



#creating IAM users
resource "aws_iam_user" "example" {
  for_each = toset(var.user_names)    # Creates one IAM user for each name in var.user_names
  name  = each.value                 # Sets user name to the current value
}



#note:
#for_each = toset(...)  
# Better: each item has a unique key, so Terraform tracks them by name — no unwanted recreation