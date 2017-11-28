resource "aws_vpc" "main" {
  cidr_block = "${var.vpc_cidr}"
  enable_dns_hostnames = true
  tags {
    Name = "main vpc"
  }
}

resource "aws_default_vpc" "default" {
    tags {
        Name = "Default VPC"
    }
}

resource "aws_subnet" "public" {
  count=3
  vpc_id     = "${aws_vpc.main.id}"
  cidr_block = "${element(var.public_subnet_cidr, count.index)}"
  availability_zone = "${element(var.azs, count.index)}"

  tags {
    Name = "public subnets"
  }
}

resource "aws_subnet" "private" {
  count=3
  vpc_id     = "${aws_vpc.main.id}"
  cidr_block = "${element(var.private_subnet_cidr, count.index)}"
  #availability_zone = "${element(var.azs, count.index)}"

  tags {
    Name = "private subnets"
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = "${aws_vpc.main.id}"
}

resource "aws_eip" "eip" {
  count=3
  vpc                       = true
}

resource "aws_nat_gateway" "gw" {
  count=3
  allocation_id = "${element(aws_eip.eip.*.id, count.index)}"
  subnet_id     = "${element(aws_subnet.public.*.id, count.index)}"
  depends_on                = ["aws_vpc.main", "aws_subnet.public",  "aws_internet_gateway.gw"]
  # ${element(var.azs, count.index)}

  tags {
    Name = "NAT Gateway in public subnets for private subnet access to internet"
  }
}

#resource "aws_route" "internet_access" {
#  count=3
#  route_table_id         = "${aws_vpc.main.main_route_table_id}"
#  destination_cidr_block = "0.0.0.0/0"
#  gateway_id = "${aws_internet_gateway.gw.id}"
#  #gateway_id             = "${element(aws_nat_gateway.gw.*.id, count.index)}"
#}

resource "aws_route_table" "private_route_table" {
    vpc_id = "${aws_vpc.main.id}"
    tags {
        Name = "Private route table"
    }
}
 
resource "aws_route" "private_route" {
        count=3
	route_table_id  = "${aws_route_table.private_route_table.id}"
        destination_cidr_block = "0.0.0.0/0"
        #gateway_id             = "${element(aws_nat_gateway.gw.*.id, count.index)}"
        gateway_id             = "${aws_internet_gateway.gw.id}"
}

resource "aws_security_group" "public_security_group" {
  name        = "public sec group"
  description = "Open access within the AZ"
  vpc_id      = "${aws_vpc.main.id}"

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "private_security_group" {
  name        = "private security group"
  description = "Open access within the AZ "
  vpc_id = "${aws_vpc.main.id}"

  ingress {
    cidr_blocks = "${var.public_subnet_cidr}"
    from_port   = 8900
    to_port     = 8900
    protocol    = "tcp"
  }
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["65.204.229.81/32","141.206.246.10/32"]
  }
  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
}
