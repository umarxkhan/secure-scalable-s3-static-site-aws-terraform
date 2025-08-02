variable "function_name" {
  type = string
}

variable "image_uri" {
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
