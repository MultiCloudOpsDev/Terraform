variable "ami" {
  default = "ami-0cae6d6fe6048ca2c"
  type = string
}
variable "instance_type" {
  default = "t3.micro"
  type = string
}
variable "cidr_block" {
  default = "10.0.0.0/16"
  type = string
}
variable "username" {
  default = "admin"
  type = string
}
variable "password" {
  default = "Rajashri123"
  type = string
}
variable "bucket_name" {
  default = "myterraformmodulesbucketshrii1"
  type = string
}