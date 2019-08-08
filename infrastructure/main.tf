provider "aws" {
  region = "us-east-1"
  profile = "default"
}

variable "domain_name" {
  default = "nayemanasir.com"
}

terraform {
  backend "s3" {
    bucket = "nayema-terraform-remote-state-storage"
    key = "nayema.github.io/terraform.tfstate"
    region = "us-east-1"
  }
}

data "aws_route53_zone" "zone" {
  name = "${var.domain_name}."
  private_zone = false
}

resource "aws_acm_certificate" "cert" {
  domain_name = var.domain_name
  validation_method = "DNS"
}

resource "aws_route53_record" "www" {
  name = "www.${var.domain_name}"
  type = "CNAME"
  zone_id = data.aws_route53_zone.zone.id
  records = [var.domain_name]
  ttl = 3600
}

resource "aws_route53_record" "cert_validation" {
  name = aws_acm_certificate.cert.domain_validation_options[0].resource_record_name
  type = aws_acm_certificate.cert.domain_validation_options[0].resource_record_type
  zone_id = data.aws_route53_zone.zone.id
  records = [aws_acm_certificate.cert.domain_validation_options[0].resource_record_value]
  ttl = 300
}

resource "aws_acm_certificate_validation" "cert_validation" {
  certificate_arn = aws_acm_certificate.cert.arn
  validation_record_fqdns = [aws_route53_record.cert_validation.fqdn]
}

locals {
  origin_domain_name = "nayema.github.io"
  origin_id = "Custom-${local.origin_domain_name}"
}

resource "aws_cloudfront_distribution" "distribution" {
  origin {
    domain_name = local.origin_domain_name
    origin_id = local.origin_id

    custom_origin_config {
      http_port = 80
      https_port = 443
      origin_keepalive_timeout = 5
      origin_protocol_policy = "https-only"
      origin_read_timeout = 30
      origin_ssl_protocols = ["TLSv1", "TLSv1.1", "TLSv1.2"]
    }
  }

  enabled = true
  is_ipv6_enabled = true
  default_root_object = null

  aliases = [var.domain_name, "www.${var.domain_name}"]

  default_cache_behavior {
    allowed_methods = ["GET", "HEAD", "OPTIONS"]
    cached_methods = ["GET", "HEAD"]
    target_origin_id = local.origin_id

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl = 0
    default_ttl = 0
    max_ttl = 0
  }

  price_class = "PriceClass_All"

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    acm_certificate_arn = aws_acm_certificate_validation.cert_validation.certificate_arn
    cloudfront_default_certificate = false
    minimum_protocol_version = "TLSv1.1_2016"
    ssl_support_method = "sni-only"
  }
}
