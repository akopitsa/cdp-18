# MAIN TF NAT MODULE

resource "aws_instance" "nat-instance" {
  ami                         = "ami-184dc970"
  instance_type               = "t2.micro"
  key_name                    = "${var.key_name}"
  depends_on                  = ["aws_security_group.for-nat-instance"]
  subnet_id                   = "${var.subnet-id}"
  vpc_security_group_ids      = ["${aws_security_group.for-nat-instance.id}"]
  source_dest_check           = false
  associate_public_ip_address = true

  root_block_device {
    volume_size           = "8"
    delete_on_termination = true
  }

  tags {
    Name = "myNATinstance"
  }
}

resource "aws_eip" "nat" {
  instance = "${aws_instance.nat-instance.id}"
  vpc      = true
}

resource "aws_security_group" "for-nat-instance" {
  //vpc_id      = "${aws_vpc.main.id}"
  vpc_id      = "${var.vpc-id}"
  name        = "security group for-nat-instance"
  description = "security group for-nat-instance"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
  }

  ingress {
    from_port   = 8140
    to_port     = 8140
    protocol    = "tcp"
    cidr_blocks = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 8140
    to_port     = 8140
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
  }

  tags {
    Name = "SG-for-nat-instance"
  }
}
