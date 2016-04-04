resource "aws_subnet" "public-service1" {
    vpc_id = "${aws_vpc.production-vpc.id}"
    cidr_block = "10.31.1.0/24"
    availability_zone = "${var.aws_zone}"
}

resource "aws_route_table_association" "puclic-service1" {
    subnet_id = "${aws_subnet.public-service1.id}"
    route_table_id = "${aws_route_table.public-route.id}"
}

resource "aws_security_group" "service1-base" {
    name = "service1-base"
    description = "for production service1"
    vpc_id = "${aws_vpc.production-vpc.id}"
    ingress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        self = true
    }
}

resource "aws_instance" "service1-web01" {
    ami = "ami-f80e0596"
    instance_type = "t2.nano"
    key_name = "key-name"    # replace with your key name.
    vpc_security_group_ids = [
      "${aws_security_group.production-base.id}",
      "${aws_security_group.service1-base.id}",
      "${aws_security_group.production-web.id}"
    ]
    subnet_id = "${aws_subnet.public-service1.id}"
    associate_public_ip_address = "true"
    private_ip = "10.31.1.11"
    tags {
        Name = "service1-web01"
    }
}

resource "aws_instance" "service1-db01" {
    ami = "ami-f80e0596"
    instance_type = "t2.nano"
    key_name = "key-name"    # replace with your key name.
    vpc_security_group_ids = [
      "${aws_security_group.production-base.id}",
      "${aws_security_group.service1-base.id}"
    ]
    subnet_id = "${aws_subnet.public-service1.id}"
    associate_public_ip_address = "true"
    private_ip = "10.31.1.101"
    tags {
        Name = "service1-db01"
    }
}

resource "aws_eip" "service1-web01-eip" {
    instance = "${aws_instance.service1-web01.id}"
    vpc = true
}

resource "aws_eip" "service1-db01-eip" {
    instance = "${aws_instance.service1-db01.id}"
    vpc = true
}

output "elastic ip of service1-web01" {
  value = "${aws_eip.service1-web01-eip.public_ip}"
}

output "elastic ip of service1-db01" {
  value = "${aws_eip.service1-db01-eip.public_ip}"
}
