terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.40.0"
    }
  }
  backend "s3" {
    bucket = "1014-statefile"
    key    = "shopifly.state"
    region = "eu-west-1"
  }

}