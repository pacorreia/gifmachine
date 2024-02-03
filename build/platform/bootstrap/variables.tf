variable "BACKEND_BUCKET_NAME" {
  description = "The name of the bucket to create"
  type        = string
}

variable "BACKEND_TABLE_NAME" {
  description = "Name of the DynamoDB table to create"
  type        = string
}

variable "AWS_REGION" {
  description = "AWS region to create resources in"
  type        = string
}

variable "TAGS" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}
