data "aws_vpc" "main" {
  id = var.vpc_id
}

data "aws_subnet" "main_public_a" {
  filter {
    name   = "tag:Name"
    values = ["Main-public-b"]
  }
}

data "aws_subnet" "main_public_a" {
  filter {
    name   = "tag:Name"
    values = ["Main-public-b"]
  }
}

