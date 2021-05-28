data "template_file" "ecmwf_tables" {
  count = "${length("${var.ECMWF-vars}")}"
  template = "${file("./../template/ECMWF_tables.txt")}"
  
  vars {
    table_name = "${aws_athena_database.db.name[0]}.${element(var.ECMWF-vars, count.index)}"
    variable = "${substr(element(var.ECMWF-vars, count.index), 0, 2) == "t2" ? var.t2m : element(var.ECMWF-vars, count.index)}"
    type = "${substr(element(var.ECMWF-vars, count.index), 0, 2) == "t2" ? "${element(var.t2m_types, count.index)}" : ""}"
  }
}

resource "aws_athena_named_query" "create_table" {
  count = "${length("${var.ECMWF-vars}")}"
  name      = "${element(var.ECMWF-vars, count.index)}-table-creation"
  database  = "${aws_athena_database.db.name[0]}"
  query     = "${element(data.template_file.tp_table.*.rendered, count.index)}"
}

resource "null_resource" "create_table" {
  count = "${length("${var.ECMWF-vars}")}"
  provisioner "local-exec" {
    command = "aws athena start-query-execution --query-string \"${element(data.template_file.tp_table.*.rendered, count.index)}\" --result-configuration OutputLocation=s3://${aws_s3_bucket.athena_query.bucket}"
  }
}
