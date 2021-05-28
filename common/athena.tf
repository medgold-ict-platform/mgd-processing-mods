resource "aws_s3_bucket" "athena_query" {
  bucket = "${var.environment}.${var.project}.athena-query"
}

resource "aws_athena_database" "db" {
  count = "${length("${var.datasets}")}"
  name   = "${element(var.datasets, count.index)}"
  bucket = "${aws_s3_bucket.athena_query.bucket}"
}
