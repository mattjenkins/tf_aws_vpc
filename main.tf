provider "aws" {
    access_key = "${var.aws_access_key}"
    secret_key = "${var.aws_secret_key}"
    region = "${var.aws_region}"
}


resource "aws_vpc" "mod" {
  cidr_block = "${var.cidr}"
  enable_dns_hostnames = "${var.enable_dns_hostnames}"
  enable_dns_support = "${var.enable_dns_support}"
  tags { 
    Name = "${var.name}" 
    Environment = "${var.environment}"
    Owner = "${var.owner}"
    Purpose = "${var.purpose}"
    CostCenter = "${var.costcenter}"
    Source = "${var.source}"
  }
}

resource "aws_internet_gateway" "mod" {
  vpc_id = "${aws_vpc.mod.id}"
}

resource "aws_route_table" "public" {
  vpc_id = "${aws_vpc.mod.id}"
  tags { Name = "${var.name}-public" }
}

resource "aws_route" "public_internet_gateway" {
    route_table_id = "${aws_route_table.public.id}"
    destination_cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.mod.id}"
}

resource "aws_route_table" "private" {
  vpc_id = "${aws_vpc.mod.id}"
  tags { Name = "${var.name}-private" }
}

resource "aws_subnet" "private" {
  vpc_id = "${aws_vpc.mod.id}"
  cidr_block = "${element(split(",", var.private_subnets), count.index)}"
  availability_zone = "${element(split(",", var.azs), count.index)}"
  count = "${length(compact(split(",", var.private_subnets)))}"
  tags { Name = "${var.name}-private" }
}

resource "aws_subnet" "public" {
  vpc_id = "${aws_vpc.mod.id}"
  cidr_block = "${element(split(",", var.public_subnets), count.index)}"
  availability_zone = "${element(split(",", var.azs), count.index)}"
  count = "${length(compact(split(",", var.public_subnets)))}"
  tags { Name = "${var.name}-public" }

  map_public_ip_on_launch = true
}

resource "aws_route_table_association" "private" {
  count = "${length(compact(split(",", var.private_subnets)))}"
  subnet_id = "${element(aws_subnet.private.*.id, count.index)}"
  route_table_id = "${aws_route_table.private.id}"
}

resource "aws_route_table_association" "public" {
  count = "${length(compact(split(",", var.public_subnets)))}"
  subnet_id = "${element(aws_subnet.public.*.id, count.index)}"
  route_table_id = "${aws_route_table.public.id}"
}
