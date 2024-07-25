locals {
  default_tags = {
    TerraformManaged = "true"
    Env              = var.env
    Application      = var.service_identifier
  }

  docker_linux_params = {
    "initProcessEnabled" : true,
    "capabilities" : {
      "add" : []
      "drop" : ["NET_RAW"]
    }
  }
}
