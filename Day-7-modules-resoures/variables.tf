variable "ami_id" {
  description = "passing value to ami"
  default = ""
  type = string
}
variable "instance_type" {
  description = "passing value to instance type"
  default = ""
  type = string
}
variable "tags" {
  description = "passing tags to instance"
  default = ""
  type = string
}