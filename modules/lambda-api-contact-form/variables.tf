variable "function_name" {
  type = string
}

variable "api_name" {
  type = string
}

variable "cors_origins" {
  type = list(string)
}

variable "timeout" {
  type    = number
  default = 30
}

variable "memory_size" {
  type    = number
  default = 128
}

variable "environment_variables" {
  type    = map(string)
  default = {}
}

variable "environment" {
  description = "Environment (dev, prod)"
  type        = string
}

variable "lambda_code_bucket" {
  type        = string
  description = "S3 bucket to upload the Lambda ZIP package"
}

variable "lambda_zip_key" {
  type        = string
  description = "S3 key (path) for the Lambda ZIP package"
  default     = "lambda-contact-form-code/app.zip"
}

variable "lambda_zip_path" {
  type        = string
  description = "Local path to Lambda ZIP file for upload (optional if managed outside Terraform)"
  default     = ""
}
variable "dynamodb_table_name" {
  description = "DynamoDB table name to store contact messages"
  type        = string
}
