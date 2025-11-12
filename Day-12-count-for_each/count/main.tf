# resource "aws_instance" "name" {
#   ami = "ami-0cae6d6fe6048ca2c"
#   instance_type = "t3.micro"
#   count = 2                               # Creates 2 EC2 instances
# #   tags = {
# #     Name ="server"
# #   }
# tags = {
#     Name ="server-${count.index}"         # Adds Name tag with index → "server-0", "server-1"
#   }
# }


resource "aws_instance" "name" {
  ami = "ami-0cae6d6fe6048ca2c"
  instance_type = "t3.micro"
  count = length(var.tags)      # Creates as many instances as items in var.tags (here: 2)
  tags = {
    Name =var.tags[count.index]   # Sets each instance Name tag using its index (0→"test", 1→"prod")
  }
}


#Note:
#count = 3     
# Drawback: if you change the list order, Terraform may destroy and recreate resources (index changes)