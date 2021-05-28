
resource "aws_s3_bucket" "datasets" {
  bucket = "${var.environment}-${var.project}-datasets"
  acl    = "private"

  tags = {
    Name        = "${var.project}"
    Environment = "${var.environment}"
  }
}