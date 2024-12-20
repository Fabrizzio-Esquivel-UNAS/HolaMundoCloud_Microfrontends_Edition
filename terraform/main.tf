# Specify AWS provider version and region
provider "aws" {
  region  = var.aws_region
  profile = var.aws_profile
}