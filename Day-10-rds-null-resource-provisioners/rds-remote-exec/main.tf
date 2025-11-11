resource "aws_db_instance" "mydb" {
    identifier = "mydb-instance"
    engine = "mysql"
    instance_class = "db.t3.micro"
    username = "admin"
    password = "password123"
    db_name= "dev"
    allocated_storage = 20
    skip_final_snapshot = true
    publicly_accessible = true
    
}

resource "aws_instance" "app_server" {
    ami           = "ami-0cae6d6fe6048ca2c" 
    instance_type = "t3.micro"
    key_name      = "my-key-pair"   # <-- This must match the name in AWS EC2 > Key Pairs

    associate_public_ip_address = true
    tags = {
        Name = "AppServer"
    }
}


resource "null_resource" "remote_sql_exec" {
  depends_on = [
    aws_db_instance.mydb,
    aws_instance.app_server
  ]

    connection {
      type        = "ssh"
      user        = "ec2-user"
      private_key = file("C:/Users/RAJASHRI/.ssh/id_ed25519")       # path to your local PEM file
      host        = aws_instance.app_server.public_ip
    }

  provisioner "file" {
    source      = "./init.sql"
    destination = "/tmp/init.sql"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo dnf install -y mariadb105",
      "mysql -h ${aws_db_instance.mydb.address} -u ${aws_db_instance.mydb.username} -p${aws_db_instance.mydb.password} ${aws_db_instance.mydb.db_name} < /tmp/init.sql"
    ]
  }

  triggers = {
    run_always = timestamp()
  }
}
