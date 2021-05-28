data "template_file" "eobs_tables" {
  count = "${length("${var.EOBS-vars}")}"
  template = "${file("./../template/EOBS_tables.txt")}"
  
  vars {
    table_name = "${aws_athena_database.db.name}.${element(var.EOBS-vars, count.index)}"
    variable = "${substr(element(var.EOBS-vars, count.index), 0, 2) == "t2" ? var.t2m : element(var.EOBS-vars, count.index)}"
    type = "${substr(element(var.EOBS-vars, count.index), 0, 2) == "t2" ? "${element(var.t2m_types, count.index)}" : ""}"
  }
}

resource "aws_athena_named_query" "create_table" {
  count = "${length("${var.EOBS-vars}")}"
  name      = "${element(var.EOBS-vars, count.index)}-table-creation"
  database  = "${aws_athena_database.db.name}"
  query     = "${element(data.template_file.tp_table.*.rendered, count.index)}"
}

resource "null_resource" "create_table" {
  count = "${length("${var.EOBS-vars}")}"
  provisioner "local-exec" {
    command = "aws athena start-query-execution --query-string \"${element(data.template_file.tp_table.*.rendered, count.index)}\" --result-configuration OutputLocation=s3://${aws_s3_bucket.athena_query.bucket}"
  }
}
