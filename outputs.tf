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
output "contact_form_endpoint" {
  description = "Contact form invoke URL"
  value       = module.lambda_api_contact_form.api_endpoint
}
output "dynamodb_table_name" {
  description = "The name of the DynamoDB table for storing contact messages"
  value       = module.lambda_api_contact_form.dynamodb_table_name
}

output "dynamodb_table_arn" {
  value = module.dynamodb.arn # assuming your dynamodb module outputs arn as 'arn'
}

