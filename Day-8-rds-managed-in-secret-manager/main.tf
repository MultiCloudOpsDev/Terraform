#custom vpc and subnets for rds
resource "aws_vpc" "name" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name="rds-vpc"
  }
}
resource "aws_subnet" "subnet-1" {
  cidr_block = "10.0.0.0/24"
  vpc_id = aws_vpc.name.id
  availability_zone = "us-east-1a"
  tags = {
    Name="rds-subnet-1"
  }
}
resource "aws_subnet" "subnet-2" {
  cidr_block = "10.0.1.0/24"
  vpc_id = aws_vpc.name.id
  availability_zone = "us-east-1b"
  tags = {
    Name="rds-subnet-2"
  }
}
#subnet group for rds
resource "aws_db_subnet_group" "sub-grp" {
  name = "mysubnetgrp"
  subnet_ids = [ aws_subnet.subnet-1.id,aws_subnet.subnet-2.id ]
  tags = {
    Name="rds-subnet-group"
  }
  depends_on = [ aws_subnet.subnet-1,aws_subnet.subnet-2 ]  #ensure subnet group created after subnets
}


#create rds
resource "aws_db_instance" "master" {  
  allocated_storage       = 10
  identifier              ="terraform-rds"
  db_name                 = "mydb"
  engine                  = "mysql"
  engine_version          = "8.0"
  instance_class          = "db.t3.micro"
  username                = "admin"
  manage_master_user_password = true    #secret manager manage this credential
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
  #deletion_protection = true

  # Skip final snapshot
  skip_final_snapshot = true
  depends_on = [ aws_db_subnet_group.sub-grp ]  #ensure rds created after subnet group 
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




#create read replica
# resource "aws_db_instance" "replica" {
#   identifier               = "my-read-replica"
#   replicate_source_db      = aws_db_instance.master.identifier
#   instance_class           = "db.t3.micro"
#   publicly_accessible      = false
#   skip_final_snapshot      = true
# }
