data "aws_s3_bucket" "existing_site" {
  bucket = var.bucket_name
}

module "cloudfront_acm" {
  source = "./modules/cloudfront-acm"

  bucket_name         = var.bucket_name
  domain_name         = var.domain_name
  s3_website_endpoint = "${var.bucket_name}.s3-website-us-east-1.amazonaws.com"

  s3_origin_id = var.bucket_name

  price_class = var.price_class
  tags        = var.tags
}
resource "aws_s3_bucket" "lambda_code_bucket" {
  bucket        = "${var.environment}-lambda-code-${random_id.suffix.hex}"
  force_destroy = true
  tags          = var.tags
}

resource "random_id" "suffix" {
  byte_length = 4
}

resource "aws_s3_bucket_versioning" "lambda_code_versioning" {
  bucket = aws_s3_bucket.lambda_code_bucket.id

  versioning_configuration {
    status = "Enabled"
  }
}
module "dynamodb" {
  source     = "./modules/dynamodb"
  table_name = "${var.environment}-contact-messages"
  tags       = var.tags
}
module "lambda_api_contact_form" {
  source      = "./modules/lambda-api-contact-form"
  environment = var.environment

  function_name       = "${var.environment}-contact-form"
  lambda_code_bucket  = aws_s3_bucket.lambda_code_bucket.bucket
  lambda_zip_key      = "lambda-contact-form-code/app.zip"
  lambda_zip_path     = "${path.module}/modules/lambda-api-contact-form/lambda-contact-form-code/app.zip"
  api_name            = "${var.environment}-contact-api"
  cors_origins        = ["https://${module.cloudfront_acm.cloudfront_domain}"]
  dynamodb_table_name = module.dynamodb.table_name
  environment_variables = {
    SENDER_EMAIL   = "form@${var.domain_name}"
    DYNAMODB_TABLE = module.dynamodb.table_name
  }
}

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

