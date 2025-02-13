resource "aws_acm_certificate" "cert" {
  domain_name       = var.env != "prod" ? "*.${var.env}.${var.domain_name}" : "*.${var.domain_name}"
  validation_method = "DNS"
}

output "certificate" {
  value = aws_acm_certificate.cert.arn
}

# import {
#   to = aws_acm_certificate.cert
#   id = "arn:aws:acm:XXXXXXXX:XXXXXXXXXXX:certificate/XXXXXXXX-XXXX-XXXXXX-XXXX-XXXXXXXXXXX"
# }