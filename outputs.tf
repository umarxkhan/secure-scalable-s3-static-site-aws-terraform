output "cloudfront_url" {
  value       = "https://${module.cloudfront_acm.cloudfront_domain}"
  description = "Public URL of the site via CloudFront"
}

/* output "contact_form_api_url" {
  value       = module.contact_form.api_endpoint
  description = "API endpoint for contact form submission"
} */

output "s3_bucket_domain" {
  value       = data.aws_s3_bucket.existing_site.bucket_regional_domain_name
  description = "S3 bucket domain used as origin"
}
