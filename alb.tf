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
    # target_group_arn = aws_lb_target_group.front_end.arn
  }
}