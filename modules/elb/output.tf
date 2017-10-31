// OUTPUT ELB

output "ELB" {
  value = "${aws_elb.my-elb.dns_name}"
}

output "elb-name" {
  value = "${aws_elb.my-elb.name}"
}

output "elb_sg_id" {
  value = "${aws_security_group.elb-securitygroup.id}"
}
