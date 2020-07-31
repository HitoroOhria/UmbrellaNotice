resource "aws_subnet" "application_public_1a" {
  availability_zone = "${var.region}a"
  cidr_block        = "10.0.1.0/24"
  vpc_id            = aws_vpc.main.id

  tags = {
    Name = "${var.project}-Application-public-1a"
  }
}

resource "aws_subnet" "application_public_1c" {
  availability_zone = "${var.region}c"
  cidr_block        = "10.0.2.0/24"
  vpc_id            = aws_vpc.main.id

  tags = {
    Name = "${var.project}-Application-public-1c"
  }
}

resource "aws_subnet" "rds_private_1a" {
  availability_zone = "${var.region}a"
  cidr_block        = "10.0.3.0/24"
  vpc_id            = aws_vpc.main.id

  tags = {
    Name = "${var.project}-RDS-private-1a"
  }
}

resource "aws_subnet" "rds_private_1c" {
  availability_zone = "${var.region}c"
  cidr_block        = "10.0.4.0/24"
  vpc_id            = aws_vpc.main.id

  tags = {
    Name = "${var.project}-RDS-private-1c"
  }
}

resource "aws_subnet" "redis_private_1a" {
  availability_zone = "${var.region}a"
  cidr_block        = "10.0.5.0/24"
  vpc_id            = aws_vpc.main.id

  tags = {
    Name = "${var.project}-Redis-private-1a"
  }
}

resource "aws_subnet" "redis_private_1c" {
  availability_zone = "${var.region}c"
  cidr_block        = "10.0.6.0/24"
  vpc_id            = aws_vpc.main.id

  tags = {
    Name = "${var.project}-Redis-private-1c"
  }
}