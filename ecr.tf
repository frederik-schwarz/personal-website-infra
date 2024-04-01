resource "aws_ecr_repository" "personal_website" {
  name                 = "personal-website"

  image_scanning_configuration {
    scan_on_push = true
  }
}