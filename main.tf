# MAIN

data "aws_region" "region" {
  name = "${var.region}"
}

data "aws_vpc" "vpc" {
  id = "${var.vpc_id}"
}

locals {
  lb_log_enabled = "${var.lb_bucket_name != "dummy" || var.lb_bucket_name != "" ? 1 : 0}"
}