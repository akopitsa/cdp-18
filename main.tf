terraform {
  backend "s3" {
    bucket  = "cdp-terraform-task"
    key     = "terraform.tfstate"
    region  = "us-east-1"
    encrypt = true
  }
}

module "base" {
  source = "./modules/base"
}

provider "aws" {
  region                  = "${var.AWS_REGION}"
  shared_credentials_file = "~/.aws/credentials"
}

module "server" {
  source = "./modules/server"
}
