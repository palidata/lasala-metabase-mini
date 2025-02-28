resource "aws_db_subnet_group" "metabase_db_subnet_group" {
  name       = "metabase-db-subnet-group"
  subnet_ids = module.vpc.private_subnets

  tags = {
    Name = "metabase-db-subnet-group"
  }
}

resource "aws_db_instance" "metabase_db" {
  identifier             = "metabase-db"
  engine                 = "postgres"
  instance_class         = "db.t3.micro"
  allocated_storage      = 20
  db_name                = var.db_name
  username               = var.db_username
  password               = var.db_password
  db_subnet_group_name   = aws_db_subnet_group.metabase_db_subnet_group.name
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  skip_final_snapshot    = true

  # Para produção, considere configurar backups, Multi-AZ, etc.
}
