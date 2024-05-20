resource "aws_alb" "main" {
  name               = "main"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_main.id]
  subnets            = [data.aws_subnet.main_public_a.id, data.aws_subnet.main_public_b.id]
}

resource "aws_lb_listener" "main" {
  load_balancer_arn = aws_alb.main.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = var.CERTIFICATE
  certificate_arn   = "arn:aws:acm:ap-southeast-2:897577706574:certificate/9d4a7b99-e64b-4355-b5fc-4485a25d23fa"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.main.arn
  }
}

resource "aws_lb_target_group" "main" {
  name     = "main"
  port     = var.PORT
  protocol = var.PROTOCOL
  target_type = "ip"
  vpc_id   = data.aws_vpc.main.id
}

resource "aws_security_group" "alb_main" {
  name        = "alb_main"
  description = "Security Group attached to alb"
  vpc_id      = data.aws_vpc.main.id
}

resource "aws_security_group_rule" "egress_anywhere" {
  security_group_id = aws_security_group.alb_main.id
  type              = "egress"
  protocol          = "-1"
  from_port         = 0
  to_port           = 0
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "cloudflare_ingress" {
  security_group_id = aws_security_group.alb_main.id
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 443
  to_port           = 443
  cidr_blocks       = data.cloudflare_ip_ranges.cloudflare.ipv4_cidr_blocks
}
