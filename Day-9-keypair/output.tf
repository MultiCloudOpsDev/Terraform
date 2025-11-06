output "public_ip" {
  value = aws_instance.web.public_ip
}
output "az" {
  value = aws_instance.web.availability_zone
}