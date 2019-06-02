resource "aws_s3_bucket" "tf_state" {
  bucket = "kyiro.net-tfstate"
  acl  = "private"

  versioning {
    enabled = true
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
}

resource "aws_s3_bucket_public_access_block" "tf_state_block" {
  bucket = "${aws_s3_bucket.tf_state.id}"

  block_public_acls   = true
  ignore_public_acls  = true
  block_public_policy = true
  restrict_public_buckets = true
}
