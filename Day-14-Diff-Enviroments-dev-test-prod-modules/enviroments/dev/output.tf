output "private_ip" {
  value =module.ec2.private_ip
}
output "server" {
  value = module.ec2.instance_name
}
output "vpc_cidr" {
  value = module.vpc.vpc_cidr
}
output "subnet_id" {
  value = module.vpc.subnet_id
}