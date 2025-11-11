# ---- Save DB credentials in AWS Secrets Manager ----
resource "aws_secretsmanager_secret" "db_secret" {
  name        = "my-db-secret"
  description = "Database credentials for my RDS"
}

resource "aws_secretsmanager_secret_version" "db_secret_value" {
  secret_id     = aws_secretsmanager_secret.db_secret.id
  secret_string = jsonencode({
    username = "admin"
    password = "password123"
    host     = "mydb-instance.cizuyikse7zo.us-east-1.rds.amazonaws.com"
    dbname   = "dev"
  })
}


# ---- Use existing EC2 instance ----
data "aws_instance" "existing_ec2" {
  filter {
    name   = "tag:Name"
    values = ["AppServer"]   # Replace with your EC2 Name tag
  }
}


# ---- Fetch existing secret ----
data "aws_secretsmanager_secret" "db_secret" {
  name = "my-db-secret"
  depends_on = [aws_secretsmanager_secret.db_secret]
}

data "aws_secretsmanager_secret_version" "db_secret_version" {
  secret_id = data.aws_secretsmanager_secret.db_secret.id
  depends_on = [aws_secretsmanager_secret_version.db_secret_value]
}

# locals {
#   db_credentials = jsondecode(data.aws_secretsmanager_secret_version.db_secret_version.secret_string)
# }

# ---- Run SQL on RDS from EC2 ----
resource "null_resource" "remote_sql_exec" {
  depends_on = [
    data.aws_secretsmanager_secret_version.db_secret_version,
    data.aws_instance.existing_ec2
  ]

  connection {
    type        = "ssh"
    user        = "ec2-user"
    host        = data.aws_instance.existing_ec2.public_ip
    private_key = file("C:/Users/RAJASHRI/.ssh/id_ed25519")    # path to your local PEM file
  }

  provisioner "file" {
    source      = "./init.sql"
    destination = "/tmp/init.sql"
  }

  provisioner "remote-exec" {
    inline = [
       # Install MySQL client if not already installed
      "sudo dnf install -y mariadb105 || true",
      # Run SQL script
    #     "mysql -h ${jsondecode(data.aws_secretsmanager_secret_version.db_secret_version.secret_string)["host"]} " 
    #   + "-u ${jsondecode(data.aws_secretsmanager_secret_version.db_secret_version.secret_string)["username"]} " 
    #   + "-p${jsondecode(data.aws_secretsmanager_secret_version.db_secret_version.secret_string)["password"]} "
    #   + "${jsondecode(data.aws_secretsmanager_secret_version.db_secret_version.secret_string)["dbname"]} < /tmp/init.sql"
    "mysql -h ${jsondecode(data.aws_secretsmanager_secret_version.db_secret_version.secret_string)["host"]} -u ${jsondecode(data.aws_secretsmanager_secret_version.db_secret_version.secret_string)["username"]} -p${jsondecode(data.aws_secretsmanager_secret_version.db_secret_version.secret_string)["password"]} ${jsondecode(data.aws_secretsmanager_secret_version.db_secret_version.secret_string)["dbname"]} < /tmp/init.sql"
    
     ]
  }
}
