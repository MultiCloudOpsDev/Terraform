#calling exsiting subnet from remote
data "aws_subnet" "subnet-1" {
   filter {
     name = "tag:Name"
     values = [ "subnet1" ]
   }
}


#---------Data source to get the latest Amazon Linux 2 AMI ---------#
data "aws_ami" "amazon_linux" {
  most_recent = true
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  owners = ["137112412989","amazon"] # Amazon official account ID or name **supports both cases
}

# Use amazon linux AMI in EC2 instance
resource "aws_instance" "web" {
  ami           = data.aws_ami.amazon_linux.id  #Using data source amazon linux ami
  instance_type = "t3.micro"
  subnet_id = data.aws_subnet.subnet-1.id   #using datasource subnet
  tags = {
    Name = "EC2-ami-linux"
  }
}


#------Data source to get the latest Ubuntu AMI------#
data "aws_ami" "ubuntu" {
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  owners = ["099720109477"] # Canonical (Ubuntu) official owner ID
}

# Use ubuntu AMI in EC2 instance
resource "aws_instance" "ubuntu_server" {
  ami           = data.aws_ami.ubuntu.id   #Using data source ubuntu ami
  instance_type = "t3.micro"
  subnet_id = data.aws_subnet.subnet-1.id    #using datasource subnet
  tags = {
    Name = "Ubuntu-ami-ec2"
  }
}


#----------Useing custom own AMIs (owner = self)-------#
# data "aws_ami" "custom" {
#   most_recent = true
#   filter {
#     name   = "name"
#     values = ["my-custom-ami-*"]      # matches any AMI starting with "my-custom-ami-"
#   }
#   owners = ["self"]  # means your own AWS account
# }

# # Use self AMI in EC2 instance
# resource "aws_instance" "custom_ami_server" {
#   ami           = data.aws_ami.custom  #Using data source custom ami
#   instance_type = "t3.micro"
#   subnet_id = data.aws_subnet.subnet-1.id     #using datasource subnet
#   tags = {
#     Name = "custom-ami"
#   }
# }
