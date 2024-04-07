data "aws_iam_policy_document" "assume_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "fargate" {
  name               = "fargate"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

data "aws_iam_policy_document" "ecr" {
  statement {
    actions = ["ecr:*"]

    resources = ["arn:aws:ecr:ap-southeast-2:897577706574:repository/personal-website"]
  }
}

resource "aws_iam_policy" "ecr" {
  name   = "ecr"
  policy = data.aws_iam_policy_document.ecr.json
}

resource "aws_iam_role_policy_attachment" "ecr" {
  role       = aws_iam_role.fargate.name
  policy_arn = aws_iam_policy.ecr.arn
}