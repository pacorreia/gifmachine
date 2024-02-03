resource "aws_s3_bucket" "terraformState" {
  bucket = var.BACKEND_BUCKET_NAME
  tags   = var.TAGS


  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_s3_bucket_versioning" "terraformBackendVersioning" {
  bucket = aws_s3_bucket.terraformState.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_public_access_block" "terraformBackendPublicAccessBlock" {
  bucket = aws_s3_bucket.terraformState.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
