
resource "aws_db_instance" "db" {
  allocated_storage    = var.allocated_storage
  engine               = var.engine
  engine_version       = var.engine_version
  instance_class       = var.instance_class
  name                 = var.name
  identifier = var.name
  #db_name = var.db_name
  username             = var.username
  password             = var.password
  skip_final_snapshot  = var.skip_final_snapshot
  allow_major_version_upgrade = var.allow_major_version_upgrade
  auto_minor_version_upgrade = var.auto_minor_version_upgrade
  apply_immediately = var.apply_immediately
  db_subnet_group_name = aws_db_subnet_group.subnet_group.name
  backup_window = var.backup_window
  backup_retention_period = var.backup_retention_period
  multi_az = var.multi_az
  vpc_security_group_ids = var.vpc_security_group_ids
  storage_encrypted = var.storage_encrypted
  enabled_cloudwatch_logs_exports = var.logs
  port = var.port
}

resource "aws_db_subnet_group" "subnet_group" {
  name       = var.subnet_group_name
  subnet_ids = var.subnet_ids
}