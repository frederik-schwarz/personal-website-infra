resource "aws_egress_only_internet_gateway" "main" {
  vpc_id = data.aws_vpc.main.id

  tags = {
    Name = "main"
  }
}