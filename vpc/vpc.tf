resource "aws_vpc" "canterlot" {
  cidr_block = "10.32.0.0/21"
  enable_dns_support = true
  enable_dns_hostnames = true

  tags {
    Name = "canterlot"
  }
}

resource "aws_vpc_ipv4_cidr_block_association" "canterlot-pod" {
  vpc_id     = "${aws_vpc.canterlot.id}"
  cidr_block = "10.128.0.0/17"
}

resource "aws_internet_gateway" "canterlot-igw" {
  vpc_id = "${aws_vpc.canterlot.id}"

  tags {
    Name = "canterlot-igw"
  }
}

resource "aws_route" "canterlot-igw-route" {
  route_table_id         = "${aws_vpc.canterlot.main_route_table_id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.canterlot-igw.id}"
}

resource "aws_nat_gateway" "canterlot-gw-a" {
  allocation_id = "${aws_eip.nat-a.id}"
  subnet_id     = "${aws_subnet.canterlot-public-a.id}"
}

resource "aws_eip" "nat-a" {
  vpc = true
  depends_on = ["aws_internet_gateway.canterlot-igw"]
}
