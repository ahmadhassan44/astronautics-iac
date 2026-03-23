data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

resource "aws_key_pair" "managed_key" {
  key_name   = "astro-ec2s-kp"
  public_key = ""

  lifecycle {
    ignore_changes = [public_key]
  }
}

resource "aws_s3_bucket" "cvat-bucket" {
  bucket           = format("cvat-bucket-%s-%s-an", data.aws_caller_identity.current.account_id, data.aws_region.current.region)
  bucket_namespace = "account-regional"
}

resource "aws_s3_bucket_public_access_block" "cvat-bucket_pab" {
  bucket = aws_s3_bucket.cvat-bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_policy" "cvat-bucket_policy" {
  bucket = aws_s3_bucket.cvat-bucket.id

  depends_on = [aws_s3_bucket_public_access_block.cvat-bucket_pab]

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "PublicReadListAccess"
        Effect    = "Allow"
        Principal = "*"
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:ListBucket"
        ]
        Resource = [
          aws_s3_bucket.cvat-bucket.arn,
          "${aws_s3_bucket.cvat-bucket.arn}/*"
        ]
      }
    ]
  })
}

resource "aws_s3_bucket_cors_configuration" "cvat-bucket_cors" {
  bucket = aws_s3_bucket.cvat-bucket.id

  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["GET", "HEAD", "PUT"]
    allowed_origins = ["*"]
    expose_headers  = ["ETag"]
    max_age_seconds = 3000
  }
}
