module "base" {
  source = "./modules/base"
}

provider "aws" {
  region = "${var.AWS_REGION}"
  shared_credentials_file = "~/.aws/credentials"
}
module "server" {
  source = "./modules/server"
}
