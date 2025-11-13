module "vpc" {
  source       = "./modules/vpc"
  cidr_block   = var.cidr_block
  subnet_1_cidr  = "10.0.1.0/24"
  subnet_2_cidr = "10.0.2.0/24"
  az1           = "us-east-1a"
  az2           = "us-east-1b"
}

module "EC2" {
  source        = "./modules/EC2"
  ami_id        = var.ami                  # Replace with valid AMI
  instance_type = var.instance_type
  subnet_1_id     = module.vpc.subnet_1_id
}

module "rds" {
  source         = "./modules/rds"
  db_identifier = "my-rds"
  #subnet_1_Id     = module.vpc.subnet_1_id
  #subnet_2_id     = module.vpc.subnet_2_id
  subnet_1_Id = module.vpc.subnet_1_id
  subnet_1_id = module.vpc.subnet_2_id
  instance_class = "db.t3.micro"
  db_name        = "mydb"
  db_user        = var.username
  db_password    = var.password
}

module "s3" {
    source = "./modules/s3"
    bucket = var.bucket_name
  
}