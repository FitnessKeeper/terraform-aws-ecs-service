data "aws_region" "region" {
  name = var.region
}

data "aws_vpc" "vpc" {
  id = var.vpc_id
}

locals {
  default_tags = {
    TerraformManaged = "true"
    Env              = var.env
    Application      = var.service_identifier
  }
}
