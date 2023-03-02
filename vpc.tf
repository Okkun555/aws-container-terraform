# --------------------------------------------------------------
# VPC
# --------------------------------------------------------------
resource "aws_vpc" "sbcntr-vpc" {
    cidr_block           = "10.0.0.0/16"
    instance_tenancy     = "default"
    enable_dns_support   = true
    enable_dns_hostnames = true

    tags = {
        Name = "sbcntr-vpc"
    }
}

# --------------------------------------------------------------
# Subnet
# --------------------------------------------------------------
resource "aws_subnet" "sbcntr-subnet-private-container-1a" {
    vpc_id = "${aws_vpc.sbcntr-vpc.id}"

    availability_zone = "ap-northeast-1a"
    cidr_block        = "10.0.8.0/24"
    map_public_ip_on_launch = false

    tags = {
        Name = "sbcntr-subnet-private-container-1a"
    }
}

resource "aws_subnet" "sbcntr-subnet-private-container-1c" {
    vpc_id = "${aws_vpc.sbcntr-vpc.id}"

    availability_zone = "ap-northeast-1c"
    cidr_block = "10.0.9.0/24"
    map_public_ip_on_launch = false

    tags = {
        Name = "sbcntr-subnet-private-container-1c"
    }
}

# --------------------------------------------------------------
# Route Table
# --------------------------------------------------------------
resource "aws_route_table" "sbcntr-route-app" {
    vpc_id = "${aws_vpc.sbcntr-vpc.id}"
    tags = {
        Project = var.project
        Name = "sbcntr-route-app"
    }
}