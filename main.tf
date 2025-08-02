data "aws_s3_bucket" "existing_site" {
  bucket = var.bucket_name
}

module "cloudfront_acm" {
  source = "./modules/cloudfront-acm"

  /* acm_certificate_arn = var.acm_certificate_arn */
  bucket_name         = var.bucket_name
  domain_name         = var.domain_name
  s3_website_endpoint = "${var.bucket_name}.s3-website-us-east-1.amazonaws.com"

  #s3_domain    = data.aws_s3_bucket.existing_site.website_endpoint
  s3_origin_id = var.bucket_name

  price_class = var.price_class
  tags        = var.tags
}


/* module "contact_form" {
  source        = "./modules/lambda-api-contact-form"
  function_name = "${var.environment}-contact-form"
  image_uri     = var.lambda_image_uri
  api_name      = "${var.environment}-contact-api"
  cors_origins  = ["https://${module.cloudfront_acm.cloudfront_domain}"]
  environment_variables = {
    SENDER_EMAIL = "form@${var.domain_name}"
  }
} */

resource "aws_s3_bucket_policy" "allow_cloudfront" {
  bucket = data.aws_s3_bucket.existing_site.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Sid    = "AllowCloudFrontReadAccess",
      Effect = "Allow",
      Principal = {
        AWS = module.cloudfront_acm.oai_iam_arn
      },
      Action   = "s3:GetObject",
      Resource = "arn:aws:s3:::${data.aws_s3_bucket.existing_site.id}/*"
    }]
  })
}
