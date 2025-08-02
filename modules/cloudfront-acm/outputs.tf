output "cloudfront_domain" {
  value       = aws_cloudfront_distribution.this.domain_name
  description = "CloudFront domain (d123.cloudfront.net)"
}

output "oai_path" {
  value       = aws_cloudfront_origin_access_identity.oai.cloudfront_access_identity_path
  description = "OAI path for bucket policy"
}

output "distribution_arn" {
  value       = aws_cloudfront_distribution.this.arn
  description = "ARN of CloudFront distribution"
}

output "oai_iam_arn" {
  value       = aws_cloudfront_origin_access_identity.oai.iam_arn
  description = "The IAM ARN of the CloudFront Origin Access Identity"
}
