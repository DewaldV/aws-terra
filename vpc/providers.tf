provider "aws" {
  region = "eu-west-2"
}

terraform {
  backend "s3" {
    bucket = "kyiro.net-tfstate"
    key    = "cloud/vpc.tfstate"
    region = "eu-west-2"
  }
}
