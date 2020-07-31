resource "aws_elasticache_cluster" "this" {
  cluster_id           = "${var.project}-pro"
  engine               = "redis"
  engine_version       = "5.0.6"
  node_type            = "cache.t2.micro"
  parameter_group_name = "default.redis5.0"
  num_cache_nodes      = 1
  port                 = 6379
  security_group_ids   = [aws_security_group.redis.id]
  subnet_group_name    = aws_elasticache_subnet_group.this.name
  availability_zone    = "${var.region}a"
}

resource "aws_elasticache_subnet_group" "this" {
  name       = "${var.project}-cache-subnet"
  subnet_ids = [aws_subnet.redis_private_1a.id, aws_subnet.redis_private_1c.id]
}