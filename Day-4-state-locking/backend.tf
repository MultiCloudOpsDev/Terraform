terraform {
  backend "s3" {
    bucket         = "myterraformbucketstatelocking"
    key            = "terraform.tfstate"
    region         = "us-east-1"
    use_lockfile   = true # Enables S3 native state locking(versions of Terraform(e.g., 1.9 and later))
  }
}
