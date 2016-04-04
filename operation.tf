resource "aws_subnet" "public-operation" {
    vpc_id = "${aws_vpc.production-vpc.id}"
    cidr_block = "10.31.254.0/24"
    availability_zone = "${var.aws_zone}"
}

resource "aws_route_table_association" "puclic-operation" {
    subnet_id = "${aws_subnet.public-operation.id}"
    route_table_id = "${aws_route_table.public-route.id}"
}

resource "aws_security_group" "operation-base" {
    name = "operation-base"
    description = "for production operation"
    vpc_id = "${aws_vpc.production-vpc.id}"
    ingress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["10.31.0.0/16"]
    }
}

resource "aws_instance" "production-operation01" {
    ami = "ami-f80e0596"
    instance_type = "t2.nano"
    key_name = "key-name"    # replace with your key name.
    vpc_security_group_ids = [
      "${aws_security_group.production-base.id}",
      "${aws_security_group.operation-base.id}"
    ]
    subnet_id = "${aws_subnet.public-operation.id}"
    associate_public_ip_address = "true"
    private_ip = "10.31.254.11"
    tags {
        Name = "production-operation01"
    }
}

resource "aws_eip" "production-operation01-eip" {
    instance = "${aws_instance.production-operation01.id}"
    vpc = true
}

output "elastic ip of production-operation01" {
  value = "${aws_eip.production-operation01-eip.public_ip}"
}
