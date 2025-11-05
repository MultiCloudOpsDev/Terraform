module "name" {
  source = "../Day-7-modules-resoures"
  ami_id =var.ami
  instance_type =var.instance_type
  tags =var.tags
}