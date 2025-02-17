resource "random_string" "bucket_suffix" {
  length  = 5
  special = false
  upper   = false
}

resource "aws_s3_bucket" "this" {
  bucket = "${var.bucket_name}-${var.env}-${random_string.bucket_suffix.result}"
  tags = {
    Project = "tf-test-cd"
  }
}