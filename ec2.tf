data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-ebs"]
  }
}

resource "aws_instance" "metabase_instance" {
  ami                    = data.aws_ami.amazon_linux.id
  instance_type          = var.instance_type
  subnet_id              = module.vpc.public_subnets[0]
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]
  associate_public_ip_address = true

  user_data = <<-EOF
    #!/bin/bash
    yum update -y
    amazon-linux-extras install docker -y
    service docker start
    usermod -a -G docker ec2-user

    # Aguarda alguns segundos para garantir que o Docker esteja rodando
    sleep 10

    # Executa o container do Metabase
    docker run -d -p 3000:3000 \
      -e "MB_DB_TYPE=postgres" \
      -e "MB_DB_DBNAME=${var.db_name}" \
      -e "MB_DB_PORT=5432" \
      -e "MB_DB_USER=${var.db_username}" \
      -e "MB_DB_PASS=${var.db_password}" \
      -e "MB_DB_HOST=${aws_db_instance.metabase_db.address}" \
      --name metabase \
      metabase/metabase
  EOF

  tags = {
    Name = "metabase-ec2"
  }
}
