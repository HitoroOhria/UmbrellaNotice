resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  instance_tenancy     = "default"
  enable_dns_support   = "true"
  enable_dns_hostnames = "true"

  tags = {
    Name = "${var.project}-vpc"
  }
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.project}-Gateway"
  }
}

resource "aws_route_table" "main" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    Name = "${var.project}-RouteTable"
  }
}

resource "aws_route_table_association" "application_public_1a" {
  subnet_id      = aws_subnet.application_public_1a.id
  route_table_id = aws_route_table.main.id
}

resource "aws_route_table_association" "application_public_1c" {
  subnet_id      = aws_subnet.application_public_1c.id
  route_table_id = aws_route_table.main.id
}

resource "aws_route_table_association" "rds_private_1a" {
  subnet_id      = aws_subnet.rds_private_1a.id
  route_table_id = aws_route_table.main.id
}

resource "aws_route_table_association" "rds_private_1c" {
  subnet_id      = aws_subnet.rds_private_1c.id
  route_table_id = aws_route_table.main.id
}

resource "aws_route_table_association" "redis_private_1a" {
  subnet_id      = aws_subnet.redis_private_1a.id
  route_table_id = aws_route_table.main.id
}

resource "aws_route_table_association" "redis_private_1c" {
  subnet_id      = aws_subnet.redis_private_1c.id
  route_table_id = aws_route_table.main.id
}