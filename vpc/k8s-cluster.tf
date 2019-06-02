resource "aws_security_group" "k8s-cluster" {
  name = "k8s-cluster"
  description = "Allow inbound traffic from cluster"
  vpc_id = "${aws_vpc.canterlot.id}"
  ingress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    self      = true
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }

  tags {
    Name = "k8s-cluster"
  }
}

resource "aws_instance" "k8s-masters" {
  count         = 1
  ami           = "${data.aws_ami.ubuntu.id}"
  instance_type = "t3.medium"
  subnet_id     = "${aws_subnet.canterlot-private-a.id}"
  key_name = "dewaldv-usw"
  iam_instance_profile = "k8s-everything"

  vpc_security_group_ids = [
    "${aws_security_group.k8s-cluster.id}",
    "${aws_security_group.bastion-internal.id}"
  ]

  tags {
    Name = "canterlot-master-${count.index}"

  }
}

resource "aws_instance" "k8s-nodes" {
  count         = 2
  ami           = "${data.aws_ami.ubuntu.id}"
  instance_type = "t3.medium"
  subnet_id     = "${aws_subnet.canterlot-private-a.id}"
  key_name = "dewaldv-usw"
  iam_instance_profile = "k8s-everything"

  vpc_security_group_ids = [
    "${aws_security_group.k8s-cluster.id}",
    "${aws_security_group.bastion-internal.id}"
  ]

  tags {
    Name = "canterlot-node-${count.index}"
  }
}

resource "aws_route53_record" "k8s-api" {
  zone_id = "${data.aws_route53_zone.cloud.id}"
  name    = "k8s-api"
  type    = "A"
  ttl     = "60"
  records = ["${aws_instance.k8s-masters.*.private_ip}"]
}
