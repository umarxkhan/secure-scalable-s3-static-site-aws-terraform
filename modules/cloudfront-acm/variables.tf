/* variable "s3_domain" {
  description = "S3 bucket domain (e.g., bucket.s3.amazonaws.com)"
  type        = string
} */

variable "s3_website_endpoint" {
  description = "S3 website endpoint domain name (e.g. bucket.s3-website-us-east-1.amazonaws.com)"
  type        = string
}

variable "s3_origin_id" {
  description = "Origin ID for CloudFront"
  type        = string
}

/* variable "acm_certificate_arn" {
  description = "ARN of ACM cert in us-east-1"
  type        = string
} */

variable "domain_name" {
  description = "Custom domain (e.g., example.com)"
  type        = string
}

variable "price_class" {
  description = "CloudFront price class"
  type        = string
  default     = "PriceClass_200"
}

variable "tags" {
  description = "Tags to apply"
  type        = map(string)
  default     = {}
}
variable "bucket_name" {
  description = "Name of the S3 bucket"
  type        = string
}
