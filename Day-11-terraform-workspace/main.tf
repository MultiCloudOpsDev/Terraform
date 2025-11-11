resource "aws_vpc" "name" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name ="cust-vpc"
  }
}




# Show current workspace ----->	terraform workspace show
# List all workspaces	----> terraform workspace list
# Create a new workspace ----->	terraform workspace new <workspace_name>
# Select (switch to) a workspace --->	terraform workspace select <workspace_name>
# Delete a workspace ----->	terraform workspace delete <workspace_name>