resource "aws_db_instance" "master" {  
  allocated_storage       = 10
  identifier              ="terraform-rds"
  db_name                 = "mydb"
  engine                  = "mysql"
  engine_version          = "8.0"
  instance_class          = "db.t3.micro"
  username                = "admin"
  password                = "Cloud123"
  publicly_accessible     = false
  db_subnet_group_name    = aws_db_subnet_group.sub-grp.id
  parameter_group_name    = "default.mysql8.0"

  # Enable backups and retention
  backup_retention_period  = 7   # Retain backups for 7 days
  backup_window            = "02:00-03:00" # Daily backup window (UTC)

  # Enable monitoring (CloudWatch Enhanced Monitoring)
  monitoring_interval      = 60  # Collect metrics every 60 seconds
  monitoring_role_arn      = aws_iam_role.rds_monitoring.arn

  # Enable performance insights
  #performance_insights_enabled          = true
  #performance_insights_retention_period = 7  # Retain insights for 7 days

  # Maintenance window
  maintenance_window = "sun:04:00-sun:05:00"  # Maintenance every Sunday (UTC)

  # Enable deletion protection (to prevent accidental deletion)
  deletion_protection = false

  # Skip final snapshot
  skip_final_snapshot = true
}

# IAM Role for RDS Enhanced Monitoring
resource "aws_iam_role" "rds_monitoring" {
  name = "rds-monitoring-role1"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "monitoring.rds.amazonaws.com"
      }
    }]
  })
}

# IAM Policy Attachment for RDS Monitoring
resource "aws_iam_role_policy_attachment" "rds_monitoring_attach" {
  role       = aws_iam_role.rds_monitoring.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonRDSEnhancedMonitoringRole"
}


# resource "aws_db_subnet_group" "sub-grp" {
#   name       = "mysubnet"
#   subnet_ids = ["subnet-0c71b574f6bd26406", "subnet-02500030ae9a30386"]  #update subnets id's

#   tags = {
#     Name = "rds-subnet-group"
#   }
# }


#with datasource subnet group create
data "aws_subnet" "sub-1" {
  filter {
    name = "tag:Name"
    values = [ "subnet1" ]
  }
}
data "aws_subnet" "sub-2" {
  filter {
    name = "tag:Name"
    values = ["subnet2"]
  }
}
resource "aws_db_subnet_group" "sub-grp" {
  name       = "mysubnet"
  subnet_ids = [data.aws_subnet.sub-1.id, data.aws_subnet.sub-2.id]  #update datasource subnets

  tags = {
    Name = "rds-subnet-group"
  }
}


#create read replica
# resource "aws_db_instance" "replica" {
#   identifier               = "my-read-replica"
#   replicate_source_db      = aws_db_instance.master.identifier
#   instance_class           = "db.t3.micro"
#   publicly_accessible      = false
#   skip_final_snapshot      = true
# }
