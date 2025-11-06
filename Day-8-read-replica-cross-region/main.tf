# --- Data Source for Existing Master DB ---
data "aws_db_instance" "master" {
  provider               = aws.master             # use master region provider
  db_instance_identifier = "terraform-rds" # existing master DB name
}

# --- Cross-Region Read Replica Creation ---
resource "aws_db_instance" "replica" {
  provider            = aws.replica          # use replica region provider
  identifier          = "cross-region-replica" # new replica name
  
  ## For cross-region replication, use db_instance_arn instead of arn.
  replicate_source_db = data.aws_db_instance.master.db_instance_arn  # use ARN for cross-region
  instance_class      = "db.t3.micro"             # instance type for replica
  publicly_accessible = false                     # optional: not publicly accessible
  skip_final_snapshot = true                      # skip snapshot on destroy
}



