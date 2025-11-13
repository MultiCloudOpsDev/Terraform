output "subnet_1_id" {
  value = "${aws_subnet.name.id}"
}
output "subnet_2_id" {
  value = "${aws_subnet.main.id}"
}
output "cidr_block" {
  value = aws_vpc.main.cidr_block
}