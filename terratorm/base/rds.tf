resource "aws_db_instance" "default" {
  allocated_storage      = 20
  storage_type           = "gp2"
  engine                 = "mysql"
  engine_version         = "8.0"
  instance_class         = "db.t2.micro"
  name                   = "${var.project}prords"
  identifier             = "${var.project}-pro-rds"
  username               = var.db_user
  password               = var.db_pass
  db_subnet_group_name   = aws_db_subnet_group.default.name
  parameter_group_name   = "${var.project}-mysql80"
  vpc_security_group_ids = [aws_security_group.rds.id]
  multi_az               = false
}

resource "aws_db_subnet_group" "default" {
  name       = "${var.project}-rds-subnet"
  subnet_ids = [aws_subnet.rds_private_1a.id, aws_subnet.rds_private_1c.id]

  tags = {
    Name = "${var.project}-rds-subnet"
  }
}