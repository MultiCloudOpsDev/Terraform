output "public_ip" {
  value =aws_instance.public.public_ip
}
output "az-public-server" {
  value = aws_instance.public.availability_zone
}
output "public-server-name" {
 value =aws_instance.public.tags  
}
output "private_ip" {
  value = aws_instance.private.private_ip
}
output "az-private-server" {
  value = aws_instance.private.availability_zone
}
output "private-server-name" {
  value = aws_instance.private.tags
}
