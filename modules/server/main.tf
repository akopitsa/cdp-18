// MAIN TF server
module "vpc-mod" {
  source = "../vpc"
}
module "elb" {
  source = "../elb"
  elb_aws_vpc_main_id = "${module.vpc-mod.aws_vpc_main_id}"
  elb_aws_subnet_id_public_1 = "${module.vpc-mod.aws_subnet_id_1}"
  elb_aws_subnet_id_public_2 = "${module.vpc-mod.aws_subnet_id_2}"
}

resource "aws_security_group" "allow-ssh-puppet" {
  vpc_id = "${module.vpc-mod.aws_vpc_main_id}"
  name = "allow-ssh"
  description = "security group that allows ssh and all egress traffic"
  egress {
      from_port = 0
      to_port = 0
      protocol = "-1"
      cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
      from_port = 22
      to_port = 22
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
      from_port = 8140
      to_port = 8140
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
  }
tags {
    Name = "allow-ssh-puppet-port"
  }
}


data "template_file" "puppet-server" {
  template = "${file("./modules/server/install_server.sh")}"

  vars {
    //dns_name = "${aws_elb.my-elb.dns_name}"
    dns_name = "${module.elb.elb-name}"
  }
}

resource "aws_launch_configuration" "example-launchconfig" {
  name_prefix     = "PuppetServer-launchconfig"
  image_id        = "${lookup(var.AMIS, var.AWS_REGION)}"
  instance_type   = "t2.micro"
  key_name = "${var.key_name}"
  security_groups = ["${aws_security_group.allow-ssh-puppet.id}"]

  root_block_device {
    volume_size           = "12"
    delete_on_termination = true
  }

  #user_data            = "#!/bin/bash\nyum update\nyum -y install epel-release\nyum -y install nginx\nsystemctl start nginx.service\nMYIP=`ifconfig | grep 'inet 10' | awk '{print $2}'`\necho 'this is: '$MYIP > /usr/share/nginx/html/index.html"
  #user_data = "${file("install_server.sh")}"
  user_data = "${data.template_file.puppet-server.rendered}"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "example-autoscaling" {
  name = "PuppetServer-autoscaling"

  #vpc_zone_identifier  = ["${aws_subnet.main-public-1.id}", "${aws_subnet.main-public-2.id}"]
  #vpc_zone_identifier       = ["${aws_subnet.main-private-1.id}", "${aws_subnet.main-private-2.id}"]
  vpc_zone_identifier       = ["${module.vpc-mod.aws_private_subnet_id_1}", "${module.vpc-mod.aws_private_subnet_id_2}"]
  launch_configuration      = "${aws_launch_configuration.example-launchconfig.name}"
  min_size                  = 1
  max_size                  = 1
  health_check_grace_period = 300
  health_check_type         = "ELB"
  load_balancers            = ["${module.elb.elb-name}"]
  force_delete              = true

  tag {
    key                 = "Name"
    value               = "PuppetServer ec2 instance"
    propagate_at_launch = true
  }
}



// ===================================================================
# resource "aws_instance" "puppet-server" {
#     ami = "${var.AMI}"
#     instance_type = "${var.instance_type}"
#     key_name = "${var.key_name}"
#     depends_on = ["aws_security_group.allow-ssh"]
#     subnet_id = "${module.vpc-mod.aws_subnet_id_1}"
#     vpc_security_group_ids = ["${aws_security_group.allow-ssh.id}"]
#     root_block_device {
#       volume_size = "12"
#       delete_on_termination = true
#     }
#     tags {
#       Name = "puppet-server"
#     }
# }
