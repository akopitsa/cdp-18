variable "key_name" {
  default = "id_rsa1"
}

variable "public_key_path" {
  default = "~/.ssh/id_rsa.pub"
}

variable "AMI" {
  default = "ami-ae7bfdb8"
}

variable "instance_type" {
  default = "t2.micro"
}
