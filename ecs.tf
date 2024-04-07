resource "aws_ecs_service" "main" {
  name            = "main"
  cluster         = data.aws_ecs_cluster.fargate.id
  task_definition = aws_ecs_task_definition.personal_website.arn
  desired_count   = 1
  network_configuration {
    subnets = [data.aws_subnet.main_private_a.id, data.aws_subnet.main_private_b.id]
    security_groups = []
  }
  load_balancer {
    target_group_arn = aws_lb_target_group.main.arn
    container_name   = "personal-website"
    container_port   = 8080
  }
}

resource "aws_ecs_task_definition" "personal_website" {
  family = "personal-website"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = 256 
  memory                   = 512 
  container_definitions = jsonencode([
    {
      name      = "personal-website"
      image     = "personal-website"
      cpu       = 256
      memory    = 512
      portMappings = [
        {
          containerPort = 8080
        }
      ]
    },
  ])
}

resource "aws_security_group" "ecs" {
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
  ipv6_cidr_blocks  = ["::"]
}

resource "aws_security_group_rule" "alb_ingress" {
  security_group_id = aws_security_group.ecs.id
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 8080
  to_port           = 8080
  source_security_group_id  = aws_security_group.alb_main.id
}