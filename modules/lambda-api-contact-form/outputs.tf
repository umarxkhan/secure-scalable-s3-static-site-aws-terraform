output "api_endpoint" {
  value       = "${aws_apigatewayv2_api.api.api_endpoint}/submit"
  description = "API endpoint for contact form"
}

output "lambda_arn" {
  value       = aws_lambda_function.this.arn
  description = "Lambda function ARN"
}

output "dynamodb_table_name" {
  value       = var.dynamodb_table_name
  description = "DynamoDB table name used by the Lambda function"
}
