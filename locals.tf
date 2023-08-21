locals {
  docker_command_override = length(var.docker_command) > 0 ? "\"command\": ${var.docker_command}" : ""
  docker_mount_points = [{
    sourceVolume  = var.task_volume == [] ? null : var.task_volume.0.name,
    containerPath = var.task_volume == [] ? null : var.task_volume.0.host_path
  }]
  docker_linux_params = {
    "initProcessEnabled" : true,
    "capabilities" : {
      "drop" : ["NET_RAW"]
    }
  }
  docker_entrypoint = var.enable_exec ? "\"entrypoint\": ${var.entrypoint}" : ""
  container_def = templatefile("${path.module}/files/container_definition.json",
    {
      service_identifier    = var.service_identifier
      task_identifier       = var.task_identifier
      image                 = var.docker_image
      docker_secret         = var.docker_secret
      memory                = var.docker_memory
      cpu                   = var.cpu
      memory_reservation    = var.docker_memory_reservation
      linux_parameters      = jsonencode(local.docker_linux_params)
      entrypoint            = local.docker_entrypoint
      app_port              = var.app_port
      host_port             = var.host_port
      command_override      = local.docker_command_override
      environment           = jsonencode(var.docker_environment)
      mount_points          = jsonencode(local.docker_mount_points)
      awslogs_region        = data.aws_region.region.name
      awslogs_group         = aws_cloudwatch_log_group.task.name
      awslogs_stream_prefix = var.service_identifier
    }
  )
}
