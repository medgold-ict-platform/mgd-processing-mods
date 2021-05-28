//
// Module: 
//

# The configuration for Terraform AWS provider 
provider "aws" {
  region  = "${var.region}"
  profile = "${var.profile}"
  version = "~> 1.30"
}

provider "aws" {
  alias   = "us-east-1"
  profile = "${var.profile}"
  region  = "${var.region}"
  version = "~> 1.30"
}


terraform {
  # The configuration for this backend will be filled in by Terragrunt
  backend "s3" {}
}