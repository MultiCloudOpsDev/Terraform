terraform {
  backend "s3" {
    bucket         = "mybuckletprojects3"  # Replace with your S3 bucket name
    key            = "Day-8/terraform.tfstate" # Path within the bucket
    region         = "us-east-1"                 # AWS region
 #   dynamodb_table = "my-terraform-lock-table"    # Replace with your DynamoDB table name
 #   encrypt        = true                        # Optional: encrypt state file at rest
  }
}