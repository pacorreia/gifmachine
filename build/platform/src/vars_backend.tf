variable "BUCKET_NAME" {
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
