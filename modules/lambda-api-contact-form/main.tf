data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

resource "aws_iam_role" "lambda" {
  name = "${var.function_name}-role${var.environment}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "lambda.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_policy" "lambda_logging" {
  name        = "${var.function_name}-basic-logging${var.environment}"
  description = "Basic CloudWatch logging for Lambda"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Effect   = "Allow"
        Resource = "arn:aws:logs:*:*:*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_logging_attach" {
  role       = aws_iam_role.lambda.name
  policy_arn = aws_iam_policy.lambda_logging.arn
}

resource "aws_iam_policy" "dynamodb_write" {
  name        = "${var.function_name}-dynamodb-write${var.environment}"
  description = "Allow Lambda to write to DynamoDB"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "dynamodb:PutItem"
        ],
        Resource = "arn:aws:dynamodb:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:table/${var.dynamodb_table_name}"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "dynamodb_write_attach" {
  role       = aws_iam_role.lambda.name
  policy_arn = aws_iam_policy.dynamodb_write.arn
}


resource "aws_lambda_function" "this" {
  function_name    = var.function_name
  role             = aws_iam_role.lambda.arn
  s3_bucket        = var.lambda_code_bucket
  s3_key           = var.lambda_zip_key
  source_code_hash = filebase64sha256(var.lambda_zip_path)

  handler = "app.lambda_handler" # Adjust if your handler function name is different
  runtime = "python3.9"

  timeout     = var.timeout
  memory_size = var.memory_size
  environment {
    variables = var.environment_variables
  }
}

resource "aws_apigatewayv2_api" "api" {
  name          = var.api_name
  protocol_type = "HTTP"
  cors_configuration {
    allow_origins = var.cors_origins
    allow_methods = ["POST"]
    allow_headers = ["Content-Type"]
  }
}

resource "aws_apigatewayv2_integration" "lambda_int" {
  api_id             = aws_apigatewayv2_api.api.id
  integration_type   = "AWS_PROXY"
  connection_type    = "INTERNET"
  integration_uri    = aws_lambda_function.this.invoke_arn
  integration_method = "POST"
}

resource "aws_apigatewayv2_route" "route_post" {
  api_id    = aws_apigatewayv2_api.api.id
  route_key = "POST /submit"
  target    = "integrations/${aws_apigatewayv2_integration.lambda_int.id}"
}

resource "aws_lambda_permission" "apigw" {
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.this.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.api.execution_arn}/*/*"
}

resource "aws_s3_object" "lambda_zip" {
  bucket = var.lambda_code_bucket
  key    = var.lambda_zip_key
  source = var.lambda_zip_path
  etag   = filemd5(var.lambda_zip_path) # Forces update if the ZIP file changes
}

resource "aws_apigatewayv2_stage" "default" {
  api_id      = aws_apigatewayv2_api.api.id
  name        = "$default"
  auto_deploy = true
}

