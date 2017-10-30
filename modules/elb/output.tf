// OUTPUT ELB

output "ELB" {
  value = "${aws_elb.my-elb.dns_name}"
}
output "elb-name" {
  value = "${aws_elb.my-elb.name}"
}
