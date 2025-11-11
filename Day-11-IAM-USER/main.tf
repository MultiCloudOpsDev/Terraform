#Create an IAM User
resource "aws_iam_user" "terraform_user" {
  name = "terraform-user"
  tags = {
    Name = "Terraform automation"
  }
}

#Create Access Keys (Credentials)
resource "aws_iam_access_key" "terraform_user_key" {
  user = aws_iam_user.terraform_user.name
}

#Attach an AWS Managed Policy
# resource "aws_iam_user_policy_attachment" "terraform_attach" {
#   user       = aws_iam_user.terraform_user.name
#   policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
# }

#Custom Policy
resource "aws_iam_policy" "s3_readonly_policy" {
  name        = "S3ReadOnlyPolicy"
  description = "Allow read-only access to S3 buckets"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action   = ["s3:Get*", "s3:List*"]
        Effect   = "Allow"
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_user_policy_attachment" "custom_attach" {
  user       = aws_iam_user.terraform_user.name
  policy_arn = aws_iam_policy.s3_readonly_policy.arn
}


#Create a Role
resource "aws_iam_role" "terraform_role" {
  name = "terraform-assume-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          AWS = aws_iam_user.terraform_user.arn
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

#Attach a Policy to the Role
resource "aws_iam_role_policy_attachment" "role_policy_attach" {
  role       = aws_iam_role.terraform_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

##Create login profile (console credentials)
# This allows the user to log in to the AWS Management Console
# resource "aws_iam_user_login_profile" "console_login" {
#   user                    = aws_iam_user.console_user.name
#   password_length         = 12
#   password_reset_required = true   # User must change password on first login
