# MAIN

provider "aws" {
  alias   = "provided"
  profile = "${var.aws_profile}"
  region  = "${var.region}"
}

data "aws_region" "region" {
  name = "${var.region}"
}

data "aws_vpc" "vpc" {
  provider = "aws.provided"
  id = "${var.vpc_id}"
}
