resource "aws_acm_certificate" "fred_schwarz_com" {
  domain_name       = "fred-schwarz.com"
  validation_method = "DNS"

  validation_option {
    domain_name       = "fred-schwarz.com"
    validation_domain = "fred-schwarz.com"
  }
}