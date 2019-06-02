data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_security_group" "bastion" {
  name = "bastion-external"
  description = "Allow inbound SSH traffic to bastion from home IP"
  vpc_id = "${aws_vpc.canterlot.id}"
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["88.97.5.36/32"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }

  tags {
    Name = "bastion-external"
  }
}

resource "aws_security_group" "bastion-internal" {
  name = "bastion-internal"
  description = "Allow traffic from bastion into private subnets"
  vpc_id = "${aws_vpc.canterlot.id}"
  ingress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    security_groups = ["${aws_security_group.bastion.id}"]
  }

  tags {
    Name = "bastion-internal"
  }
}
resource "aws_instance" "bastion" {
  ami           = "${data.aws_ami.ubuntu.id}"
  instance_type = "t3.nano"
  associate_public_ip_address = true
  subnet_id     = "${aws_subnet.canterlot-public-a.id}"
  key_name = "dewaldv-usw"
  vpc_security_group_ids = ["${aws_security_group.bastion.id}"]

  tags {
    Name = "canterlot-bastion"
  }
}

resource "aws_eip" "bastion" {
  vpc = true
  instance = "${aws_instance.bastion.id}"
}

data "aws_route53_zone" "cloud" {
  name         = "cloud.kyiro.net."
  private_zone = false
}

resource "aws_route53_record" "bastion" {
  zone_id = "${data.aws_route53_zone.cloud.id}"
  name    = "bastion"
  type    = "A"
  ttl     = "60"
  records = ["${aws_eip.bastion.public_ip}"]
}
