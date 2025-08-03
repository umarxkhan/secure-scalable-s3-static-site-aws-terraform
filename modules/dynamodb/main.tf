resource "aws_dynamodb_table" "contact_messages" {
  name         = var.table_name
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "MessageID"

  attribute {
    name = "MessageID"
    type = "S"
  }

  tags = var.tags
}
