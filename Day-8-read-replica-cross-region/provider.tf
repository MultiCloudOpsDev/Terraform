# --- Master Region Provider (us-east-1) ---
provider "aws" {
  alias  = "master"         # alias for master region
  region = "us-east-1"      # master DB region
}

# --- Replica Region Provider (us-west-2) ---
provider "aws" {
  alias  = "replica"    # alias for replica region
  region = "us-west-2"      # replica DB region
}


# --- Notes ---
# Terraform supports one region per provider.
# For cross-region replication, define two providers.
# Replica resource must use the second (destination) provider.
# Always use ARN (not identifier) for cross-region replicate_source_db.