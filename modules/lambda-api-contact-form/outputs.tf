output "api_endpoint" {
  value       = "${aws_apigatewayv2_api.api.api_endpoint}/submit"
  description = "API endpoint for contact form"
}

output "lambda_arn" {
  value       = aws_lambda_function.this.arn
  description = "Lambda function ARN"
}
