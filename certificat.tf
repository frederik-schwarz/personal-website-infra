resource "aws_acm_certificate" "fredwebhosting" {
  domain_name       = "fredwebhosting.com"
  validation_method = "DNS"

  validation_option {
    domain_name       = "fredwebhosting.com"
    validation_domain = "fredwebhosting.com"
  }
}