// OUTPUT nat

output "nat_subnet_id" {
  value = "${var.subnet-id}"
}

output "aws_vpc_id" {
  value = "${var.vpc-id}"
}

output "nat_instance_id" {
  value = "${aws_instance.nat-instance.id}"
}
