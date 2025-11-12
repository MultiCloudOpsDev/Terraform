
resource "aws_security_group" "devops_project" {
  name        = "devops-project"
  description = "Allow restricted inbound traffic"

  # Dynamic block to create multiple ingress (inbound) rules
  dynamic "ingress" {
    for_each = var.allowed_ports                          # Loops through each item in allowed_ports variable (a map)
    content {
      description = "Allow access to port ${ingress.key}"
      from_port   = ingress.key                             # Start port = key from the map (e.g., 22)
      to_port     = ingress.key                              # End port = same port (single-port rule)
      protocol    = "tcp"
      cidr_blocks = [ingress.value]                         # IP/CIDR range allowed for that port (value from the map)
    }
     
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "devops-project"
  }
}