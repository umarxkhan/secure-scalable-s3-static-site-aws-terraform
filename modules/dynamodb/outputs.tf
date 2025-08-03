output "table_name" {
  value = aws_dynamodb_table.contact_messages.name
}

output "arn" {
  value       = aws_dynamodb_table.contact_messages.arn
  description = "The ARN of the DynamoDB table"
}
