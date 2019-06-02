## Canterlot Private A

resource "aws_subnet" "canterlot-private-a" {
  vpc_id     = "${aws_vpc.canterlot.id}"
  availability_zone = "eu-west-2a"
  cidr_block = "10.32.0.0/24"

  tags {
    Name = "canterlot-private-a"
  }
}

resource "aws_route_table" "canterlot-private-a" {
  vpc_id = "${aws_vpc.canterlot.id}"

  tags {
    Name = "canterlot-private-a"
  }
}

resource "aws_route" "canterlot-private-a-default" {
  route_table_id = "${aws_route_table.canterlot-private-a.id}"
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id = "${aws_nat_gateway.canterlot-gw-a.id}"
}

#resource "aws_route_table_association" "canterlot-private-a" {
#  subnet_id = "${aws_route_table.canterlot-private-a.id}"
#  route_table_id = "${aws_subnet.canterlot-private-a.id}"
#}

## Canterlot Public A

resource "aws_subnet" "canterlot-public-a" {
  vpc_id     = "${aws_vpc.canterlot.id}"
  availability_zone = "eu-west-2a"
  cidr_block = "10.32.3.0/24"

  tags {
    Name = "canterlot-public-a"
  }
}

resource "aws_route_table" "canterlot-public-a" {
  vpc_id = "${aws_vpc.canterlot.id}"

  tags {
    Name = "canterlot-public-a"
  }
}

resource "aws_route" "canterlot-public-a-default" {
  route_table_id = "${aws_route_table.canterlot-public-a.id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = "${aws_internet_gateway.canterlot-igw.id}"
}

#resource "aws_route_table_association" "canterlot-public-a" {
#  subnet_id = "${aws_route_table.canterlot-public-a.id}"
#  route_table_id = "${aws_subnet.canterlot-public-a.id}"
#}

## Canterlot Pod 1

resource "aws_subnet" "canterlot-pod-1" {
  vpc_id     = "${aws_vpc_ipv4_cidr_block_association.canterlot-pod.vpc_id}"
  cidr_block = "${aws_vpc_ipv4_cidr_block_association.canterlot-pod.cidr_block}"

  tags {
    Name = "canterlot-pod-1"
  }
}

resource "aws_route_table" "canterlot-pod-1" {
  vpc_id = "${aws_vpc.canterlot.id}"

  tags {
    Name = "canterlot-pod-1"
  }
}

#resource "aws_route_table_association" "canterlot-pod-1" {
#  subnet_id = "${aws_route_table.canterlot-pod-1.id}"
#  route_table_id = "${aws_subnet.canterlot-pod-1.id}"
#}
