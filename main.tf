# MAIN

data "aws_region" "current" {
  current = true
}

data "aws_vpc" "vpc" {
  id = "${var.vpc_id}"
}
