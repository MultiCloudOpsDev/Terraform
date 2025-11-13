output "public_ip" {
  value = module.EC2.public_ip
}
output "vpc" {
  value = module.vpc.cidr_block
}
output "bucket" {
  value = module.s3.bucket_name
}
output "rds_name" {
  value = module.rds.rds_name
}