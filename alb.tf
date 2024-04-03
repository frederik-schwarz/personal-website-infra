resource "aws_alb" "main" {
  name               = "main"
  internal           = false
  load_balancer_type = "application"
#   security_groups    = [aws_security_group.lb_sg.id]
  subnets            = [data.aws_subnet.main_public_a.id, data.aws_subnet.main_public_b.id]
}

resource "aws_lb_listener" "main" {
  load_balancer_arn = aws_alb.main.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-TLS13-1-2-2021-06"
#   certificate_arn   = "arn:aws:iam::187416307283:server-certificate/test_cert_rab3wuqwgja25ct3n4jdj2tzu4"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.main.arn
  }
}

resource "aws_lb_target_group" "main" {
  name     = "main"
  port     = 80
  protocol = "HTTP"
  vpc_id   = data.aws_vpc.main.id
}

resource "aws_security_group" "alb_main" {
  name        = "alb_main"
  description = "Security Group attached to alb"
  vpc_id      = data.aws_vpc.main.id
}

resource "aws_vpc_security_group_ingress_rule" "alb_main_ingress_clouflare" {
  security_group_id = aws_security_group.alb_main.id

  cidr_ipv4   = "10.0.0.0/8"
  from_port   = 80
  ip_protocol = "tcp"
  to_port     = 80
}