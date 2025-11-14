output "private_ip" {
  value = aws_instance.name.private_ip
}
output "instance_name" {
  value = aws_instance.name.tags
}