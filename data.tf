data "aws_vpc" "main" {
  id = var.vpc_id
}

data "aws_subnet" "main_public_a" {
  filter {
    name   = "tag:Name"
    values = ["Main-public-a"]
  }
}

data "aws_subnet" "main_public_b" {
  filter {
    name   = "tag:Name"
    values = ["Main-public-b"]
  }
}

data "aws_ecs_cluster" "fargate" {
  cluster_name = "fargate"
}

data "cloudflare_ip_ranges" "cloudflare" {}

