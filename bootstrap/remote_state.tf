resource "aws_kms_key" "state_key" {
  description             = "${module.label.id}-terrafrom-remote-state key"
  deletion_window_in_days = 10

  tags = module.label.tags
}

resource "aws_s3_bucket" "s3_state" {
  bucket = "${module.label.id}-tf-remote-state"
  acl    = "private"

  versioning {
    enabled = true
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = aws_kms_key.state_key.arn
        sse_algorithm     = "aws:kms"
      }
    }
  }

  lifecycle {
    prevent_destroy = true
  }

  tags = module.label.tags
}

resource "aws_ssm_parameter" "s3_state_bucket_name" {
  name  = "/terraform/s3_state_bucket_name"
  type  = "SecureString"
  value = aws_s3_bucket.s3_state.bucket
}

# create a dynamodb table for locking the state file
resource "aws_dynamodb_table" "dynamodb_terraform_state_lock" {
  name           = "${module.label.id}-terrafrom-remote-state-lock-dynamo"
  hash_key       = "LockID"
  read_capacity  = 20
  write_capacity = 20

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = module.label.tags
}

resource "aws_ssm_parameter" "dynamodb_terraform_state_lock" {
  name  = "/terraform/dynamodb_state_lock_table_name"
  type  = "SecureString"
  value = aws_dynamodb_table.dynamodb_terraform_state_lock.name
}
