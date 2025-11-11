provider "aws" {
  region = "us-east-1"
}
provider "aws" {
  region = "us-west-2"
  alias = "west-2"             #same account diff region
}

provider "aws" {
  region = "us-west-1"
  alias = "west-1"
  profile = "shrii"       #same account but diff IAM user 
}