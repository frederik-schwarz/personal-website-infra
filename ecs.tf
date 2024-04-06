resource "aws_ecs_service" "main" {
  name            = "main"
  cluster         = data.aws_ecs_cluster.fargate.id
  task_definition = aws_ecs_task_definition.personal_website.arn
  desired_count   = 1

  load_balancer {
    target_group_arn = aws_lb_target_group.main.arn
    container_name   = "personal-website"
    container_port   = 80
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
          containerPort = 80
        }
      ]
    },
  ])
}