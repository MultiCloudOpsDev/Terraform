variable "tags" {
  default = ["test","prod"]    # List of names for the instances
  type = list(string)         # The type is explicitly set to a list of strings
}