terraform {
  backend "s3" {
    bucket = "mybuckletprojects3"
    key    = "terraform.tfstate"
    region = "us-east-1"
  }
}
