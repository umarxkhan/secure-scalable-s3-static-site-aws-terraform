variable "bucket_name" {
  description = "Existing S3 bucket name"
  type        = string
}

variable "domain_name" {
  description = "Custom domain (e.g., mubarak.khan.cloud1.engineer)"
  type        = string
}

variable "environment" {
  description = "Environment (dev, prod)"
  type        = string
  default     = "dev"
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

variable "s3_website_endpoint" {
  description = "S3 website endpoint domain name (e.g. bucket.s3-website-us-east-1.amazonaws.com)"
  type        = string
  default     = "mubarak.khan.cloud1.engineer.s3-website-us-east-1.amazonaws.com"
}

variable "lambda_zip_key" {
  description = "The S3 key (path) for the Lambda zip file"
  type        = string
}

variable "lambda_zip_path" {
  description = "Local path to the Lambda zip file"
  type        = string
}


