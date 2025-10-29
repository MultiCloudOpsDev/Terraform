terraform {
  backend "s3" {
    bucket = "mys3terraformbucket1"
    key    = "Day-2/terraform.tfstate"
    region = "us-east-1"
  }
}
