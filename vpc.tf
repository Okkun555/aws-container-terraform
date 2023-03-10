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

# アプリ用コンテナの設定

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
# Route Table（アプリ用コンテナ）
# --------------------------------------------------------------
resource "aws_route_table" "sbcntr-route-table" {
    vpc_id = "${aws_vpc.sbcntr-vpc.id}"
    tags = {
        Project = var.project
        Name = "${var.project}-route-table"
    }
}

resource "aws_route_table_association" "sbcntr-route-table_1a" {
    route_table_id = aws_route_table.sbcntr-route-table.id
    subnet_id = aws_subnet.sbcntr-subnet-private-container-1a.id
}

resource "aws_route_table_association" "sbcntr-route-table_1c" {
    route_table_id = aws_route_table.sbcntr-route-table.id
    subnet_id = aws_subnet.sbcntr-subnet-private-container-1c.id
}

# DB周りの設定
# --------------------------------------------------------------
# Subnet
# --------------------------------------------------------------
resource "aws_subnet" "sbcntr-subnet-private-db-1a" {
    vpc_id = "${aws_vpc.sbcntr-vpc.id}"

    availability_zone = "ap-northeast-1a"
    cidr_block = "10.0.16.0/24"
    map_public_ip_on_launch = false

    tags = {
        Name = "sbcntr-subnet-private-db-1a"
    }
}

resource "aws_subnet" "sbcntr-subnet-private-db-1c" {
    vpc_id = "${aws_vpc.sbcntr-vpc.id}"

    availability_zone = "ap-northeast-1c"
    cidr_block = "10.0.17.0/24"
    map_public_ip_on_launch = false

    tags = {
        Name = "sbcntr-subnet-private-db-1c"
    }
}

# --------------------------------------------------------------
# Route Table（DB用）
# --------------------------------------------------------------
resource "aws_route_table" "sbcntr-route-db" {
    vpc_id = "${aws_vpc.sbcntr-vpc.id}"
    tags = {
        Project = var.project
        Name = "${var.project}-route-db"
    }
}

resource "aws_route_table_association" "sbcntr-route-db-1a" {
    route_table_id = aws_route_table.sbcntr-route-db.id
    subnet_id = aws_subnet.sbcntr-subnet-private-db-1a.id
}

resource "aws_route_table_association" "sbcntr-route-db-1c" {
    route_table_id = aws_route_table.sbcntr-route-db.id
    subnet_id = aws_subnet.sbcntr-subnet-private-db-1c.id
}

# Ingress周りの設定
# --------------------------------------------------------------
# Subnet （Public)
# --------------------------------------------------------------
resource "aws_subnet" "sbcntr-subnet-public-ingress-1a" {
    vpc_id = "${aws_vpc.sbcntr-vpc.id}"

    availability_zone = "ap-northeast-1a"
    cidr_block = "10.0.0.0/24"
    map_public_ip_on_launch = true

    tags = {
        Name = "sbcntr-subnet-public-ingress-1a"
    }
}

resource "aws_subnet" "sbcntr-subnet-public-ingress-1c" {
    vpc_id = "${aws_vpc.sbcntr-vpc.id}"

    availability_zone = "ap-northeast-1c"
    cidr_block = "10.0.0.1/24"
    map_public_ip_on_launch = true

    tags = {
        Name = "sbcntr-subnet-public-ingress-1c"
    }
}

# --------------------------------------------------------------
# Route Table（Ingress用）
# --------------------------------------------------------------
resource "aws_route_table" "sbcntr-route-ingress" {
    vpc_id = "${aws_vpc.sbcntr-vpc.id}"
    tags = {
        Project = var.project
        Name = "${var.project}-route-ingress"
    }
}

resource "aws_route" "sbcntr-route-ingress" {
    destination_cidr_block = "0.0.0.0/0"
    route_table_id = aws_route_table.sbcntr-route-ingress.id
    gateway_id = aws_internet_gateway.sbcntr-igw.id
}

resource "aws_route_table_association" "sbcntr-route-ingress-1a" {
    route_table_id = aws_route_table.sbcntr-route-ingress.id
    subnet_id = sbcntr-subnet-public-ingress-1a.id
}

resource "aws_route_table_association" "sbcntr-route-ingress-1c" {
    route_table_id = aws_route_table.sbcntr-route-ingress.id
    subnet_id = sbcntr-subnet-public-ingress-1c.id
}

# インターネットへ通信するためのゲートウェイ作成
resource "aws_internet_gateway" "sbcntr-igw" {

}
