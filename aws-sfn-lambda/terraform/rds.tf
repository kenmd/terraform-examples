
resource "aws_rds_cluster" "serverless_mysql" {
  cluster_identifier = var.name
  engine             = "aurora"
  engine_mode        = "serverless"
  engine_version     = "5.6.10a"

  database_name   = var.db_database
  master_username = var.db_username
  master_password = var.db_password

  vpc_security_group_ids = [aws_security_group.mysql.id]
  db_subnet_group_name   = aws_db_subnet_group.default.name

  backup_retention_period = 7
  skip_final_snapshot     = true # for test

  scaling_configuration {
    auto_pause               = true
    min_capacity             = 1
    max_capacity             = 16
    seconds_until_auto_pause = 300
  }
}

resource "aws_db_subnet_group" "default" {
  name = var.name

  subnet_ids = [
    aws_subnet.protected_a.id,
    aws_subnet.protected_c.id,
  ]
}

output "db-endpont" {
  value = aws_rds_cluster.serverless_mysql.endpoint
}
