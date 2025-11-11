#Create an S3 bucket for logs
resource "aws_s3_bucket" "log_bucket" {
  bucket = "rajashri-ec2-logs-bucket"
  force_destroy = true
}


#IAM Role for EC2 to access S3
resource "aws_iam_role" "ec2_s3_role" {
  name = "ec2-s3-access-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

#Policy to allow EC2 to read/write logs in the S3 bucket
resource "aws_iam_policy" "s3_access_policy" {
  name        = "EC2S3AccessPolicy"
  description = "Allow EC2 to put and get objects in the log bucket"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:PutObject",
          "s3:GetObject",
          "s3:ListBucket"
        ]
        Resource = [
          aws_s3_bucket.log_bucket.arn,
          "${aws_s3_bucket.log_bucket.arn}/*"
        ]
      }
    ]
  })
}

#Attach the policy to the role
resource "aws_iam_role_policy_attachment" "attach_policy" {
  role       = aws_iam_role.ec2_s3_role.name
  policy_arn = aws_iam_policy.s3_access_policy.arn
}

#Create an Instance Profile to link role with EC2
resource "aws_iam_instance_profile" "ec2_instance_profile" {
  name = "ec2-instance-profile"
  role = aws_iam_role.ec2_s3_role.name
}

#EC2 instance with IAM role
resource "aws_instance" "ec2_with_s3" {
  ami                    = "ami-0cae6d6fe6048ca2c"  # Amazon Linux 2
  instance_type          = "t3.micro"
  iam_instance_profile    = aws_iam_instance_profile.ec2_instance_profile.name
  key_name               = "us-east-1"   # Change to your EC2 key pair name

  user_data = <<-EOF
              #!/bin/bash
              yum install -y awscli
              echo "This is a sample log file" > /var/log/sample.log
              aws s3 cp /var/log/sample.log s3://${aws_s3_bucket.log_bucket.bucket}/
              EOF

  tags = {
    Name = "EC2-with-S3"
  }
}
