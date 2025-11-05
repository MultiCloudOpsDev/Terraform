#exsting subnets calling from cloud
data "aws_subnet" "sub-1" {
  filter {
    name = "tag:Name"
    values = [ "subnet1" ]
  }
}
data "aws_subnet" "sub-2" {
  filter {
    name ="tag:Name"
    values = [ "subnet2" ]
  }
}

#create subnet group with using datasource
resource "aws_db_subnet_group" "sub-group" {
  name = "rds-subnet"
  subnet_ids = [ data.aws_subnet.sub-1.id,data.aws_subnet.sub-2.id ]
  tags ={
    Name="db-subnet-group"
  }  
}