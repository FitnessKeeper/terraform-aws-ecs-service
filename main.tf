# MAIN

data "aws_region" "current" {
  current = true
}

data "aws_vpc" "vpc" {
  tags {
    Name = "${var.vpc_name}"
  }
}
