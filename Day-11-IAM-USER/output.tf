output "access_key" {
  value = aws_iam_access_key.terraform_user_key.id
}

output "secret_key" {
  value = aws_iam_access_key.terraform_user_key.secret
  sensitive = true
}

# output "console_user_name" {
#   value = aws_iam_user.console_user.name
# }