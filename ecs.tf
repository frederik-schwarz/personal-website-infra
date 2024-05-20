resource "aws_ecs_service" "main" {
  name            = "main"
  cluster         = data.aws_ecs_cluster.fargate.id
  task_definition = aws_ecs_task_definition.personal_website.arn
  desired_count   = 1
  launch_type     = "FARGATE"
  network_configuration {
    subnets = [data.aws_subnet.main_public_a.id, data.aws_subnet.main_public_b.id]
    security_groups = [aws_security_group.ecs.id]
    assign_public_ip = true
  }
  load_balancer {
    target_group_arn = aws_lb_target_group.main.arn
    container_name   = "personal-website"
    container_port   = var.PORT
  }
}

resource "aws_ecs_task_definition" "personal_website" {
  family = "personal-website"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = 256 
  memory                   = 512 
  execution_role_arn       = "arn:aws:iam::897577706574:role/ecsTaskExecutionRole"
  task_role_arn            = aws_iam_role.fargate.arn
  runtime_platform {
    cpu_architecture = "ARM64"
  }
  container_definitions    = jsonencode([
    {
      name      = "personal-website"
      image     = "897577706574.dkr.ecr.ap-southeast-2.amazonaws.com/personal-website:latest"
      cpu       = 256
      memory    = 512
      portMappings = [
        {
          containerPort = var.PORT
        }
      ]
    },
  ])
}

resource "aws_security_group" "ecs" {
  name        = "ecs"
  description = "Security Group attached to alb"
  vpc_id      = data.aws_vpc.main.id
}

resource "aws_security_group_rule" "ecs_egress_anywhere" {
  security_group_id = aws_security_group.ecs.id
  type              = "egress"
  protocol          = "-1"
  from_port         = 0
  to_port           = 0
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "alb_ingress" {
  security_group_id = aws_security_group.ecs.id
  type              = "ingress"
  protocol          = "tcp"
  from_port         = var.PORT
  to_port           = var.PORT
  source_security_group_id  = aws_security_group.alb_main.id
}