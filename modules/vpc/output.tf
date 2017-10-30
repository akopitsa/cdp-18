# VPC output

output "aws_vpc_main_id" {
  value = "${aws_vpc.main.id}"
}

output "aws_subnet_id_1" {
  value = "${aws_subnet.main-public-1.id}"
}

output "aws_subnet_id_2" {
  value = "${aws_subnet.main-public-2.id}"
}

output "aws_private_subnet_id_1" {
  value = "${aws_subnet.main-private-1.id}"
}

output "aws_private_subnet_id_2" {
  value = "${aws_subnet.main-private-2.id}"
}
