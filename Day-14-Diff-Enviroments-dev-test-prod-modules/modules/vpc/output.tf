output "vpc_cidr" {
  value = aws_vpc.name.cidr_block
}
output "subnet_id" {
  value = aws_subnet.name.id
}