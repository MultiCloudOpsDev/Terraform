variable "tags" {
  default = ["dev","prod"]    # List of names for the instances
  type = list(string)         # The type is explicitly set to a list of strings
}

variable "bucket_name" {
  default = ["mybucketshriii123shrii","terraformmybicketshriii233"]
  type = list(string)
}

#example-3 creating IAM users 
variable "user_names" {
  description = "IAM usernames"
  type        = list(string)
  default     = ["user1", "user3"]
}