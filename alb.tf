resource "aws_lb" "metabase_alb" {
  name               = "metabase-alb"
  internal           = false
  load_balancer_type = "application"
  subnets            = module.vpc.public_subnets
  security_groups    = [aws_security_group.alb_sg.id]

  tags = {
    Name = "metabase-alb"
  }
}

resource "aws_security_group" "alb_sg" {
  name        = "alb-sg"
  description = "Security group for the ALB allowing HTTPS"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description = "Allow HTTPS traffic"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow HTTP traffic for redirection"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Crie um Target Group para a instância EC2
resource "aws_lb_target_group" "metabase_tg" {
  name        = "metabase-tg"
  port        = 3000
  protocol    = "HTTP"
  target_type = "instance"  # ou "ip", se preferir, dependendo da sua configuração
  vpc_id      = module.vpc.vpc_id

  health_check {
    path                = "/"
    protocol            = "HTTP"
    matcher             = "200-399"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}

# Listener HTTPS no ALB
resource "aws_lb_listener" "https_listener" {
  load_balancer_arn = aws_lb.metabase_alb.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = var.acm_certificate_arn  # Adicione essa variável no variables.tf

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.metabase_tg.arn
  }
}

# Listener HTTP para redirecionar para HTTPS
resource "aws_lb_listener" "http_listener" {
  load_balancer_arn = aws_lb.metabase_alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}
