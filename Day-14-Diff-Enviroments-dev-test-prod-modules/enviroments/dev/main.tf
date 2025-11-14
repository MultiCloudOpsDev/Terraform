module "ec2" {
  source = "../../modules/ec2"
  ami =var.ami_id
  instance_type =var.instance_type
  tags = var.tags
  az = var.availability_zone
  subnet_id =module.vpc.subnet_id
  depends_on = [ module.vpc ]
}
module "vpc" {
  source = "../../modules/vpc"
  cidr_block = var.vpc_cidr
  az = var.availability_zone
  subnet_cidr = var.subnet_id
  tags = var.tags
}
module "s3" {
  source = "../../modules/s3"
  bucket_name = var.bucket_name
  region = var.region
}