resource "aws_vpc" "production-vpc" {
    cidr_block = "10.31.0.0/16"
    instance_tenancy = "default"
    enable_dns_support = "true"
    enable_dns_hostnames = "false"
    tags {
      Name = "for production"
    }
}

resource "aws_internet_gateway" "production-igw" {
    vpc_id = "${aws_vpc.production-vpc.id}"
}

resource "aws_route_table" "public-route" {
    vpc_id = "${aws_vpc.production-vpc.id}"
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = "${aws_internet_gateway.production-igw.id}"
    }
}

resource "aws_security_group" "production-base" {
    name = "production-base"
    description = "for production"
    vpc_id = "${aws_vpc.production-vpc.id}"
    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["xx.xx.xx.xx/32"]  # replace with your IP address.
    }
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

resource "aws_security_group" "production-web" {
    name = "production-web"
    description = "for production"
    vpc_id = "${aws_vpc.production-vpc.id}"
    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        from_port = 443
        to_port = 443
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
}
