#managed password + replicas, the only engine that supports both is Aurora MySQL (or Aurora PostgreSQL).
#AWS RDS for MySQL does not currently support creating read replicas when manage_master_user_password = true

#Fetch Existing Master DB Using Data Source
data "aws_db_instance" "master" {
  db_instance_identifier = "terraform-rds"   # existing DB name
}

#create read replica using existing master db
resource "aws_db_instance" "read_replica" {
  identifier          = "my-read-replica"
  replicate_source_db = data.aws_db_instance.master.id  #link to master DB (id=identifier)
  instance_class      = "db.t3.micro"
  publicly_accessible = false
  skip_final_snapshot = true

  # Optional parameters
  apply_immediately    = true
  storage_type         = "gp2"
  auto_minor_version_upgrade = true
  copy_tags_to_snapshot = true
}

