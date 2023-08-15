locals {
  docker_command_override = length(var.docker_command) > 0 ? "\"command\": [\"${var.docker_command}\"]," : ""
  docker_mount_points = [{
    sourceVolume  = var.task_volume.0.name,
    containerPath = var.task_volume.0.host_path
  }]
  container_def = templatefile("${path.module}/files/container_definition.json",
    {
      service_identifier    = var.service_identifier
      task_identifier       = var.task_identifier
      image                 = var.docker_image
      docker_secret         = var.docker_secret
      memory                = var.docker_memory
      cpu                   = var.cpu
      memory_reservation    = var.docker_memory_reservation
      app_port              = var.app_port
      host_port             = var.host_port
      command_override      = local.docker_command_override
      environment           = jsonencode(var.docker_environment)
      mount_points          = jsonencode(local.docker_mount_points)
      awslogs_region        = data.aws_region.region.name
      awslogs_group         = "${var.service_identifier}-${var.task_identifier}"
      awslogs_stream_prefix = var.service_identifier
      volume_name           = var.task_volume.0.name
      ecs_data_volume_path  = var.task_volume.0.host_path
    }
  )
}

resource "aws_ecs_task_definition" "task" {
  family                   = "${var.service_identifier}-${var.task_identifier}"
  container_definitions    = local.container_def
  network_mode             = var.network_mode
  requires_compatibilities = var.req_compatibilities
  cpu                      = var.cpu
  memory                   = var.memory
  execution_role_arn       = aws_iam_role.task_execution_role.arn
  task_role_arn            = aws_iam_role.task.arn

  dynamic "volume" {
    for_each = var.task_volume
    content {
     name      = var.task_volume == [] ? null : var.task_volume.0.name
    }
  }

  tags = local.default_tags
}

resource "aws_ecs_service" "service" {
  name                               = "${var.service_identifier}-${var.task_identifier}-service"
  cluster                            = var.ecs_cluster_arn
  task_definition                    = aws_ecs_task_definition.task.arn
  desired_count                      = var.ecs_desired_count
  launch_type                        = var.launch_type
  iam_role                           = var.network_mode != "awsvpc" ? aws_iam_role.service.arn : null
  deployment_maximum_percent         = var.ecs_deployment_maximum_percent
  deployment_minimum_healthy_percent = var.ecs_deployment_minimum_healthy_percent
  health_check_grace_period_seconds  = var.ecs_health_check_grace_period

  deployment_controller {
    type = var.deployment_controller_type
  }

  dynamic "ordered_placement_strategy" {
    for_each = var.placement_strategy
    content {
      type  = var.ecs_placement_strategy_type
      field = var.ecs_placement_strategy_field
    }
  }

  dynamic "network_configuration" {
    for_each = var.network_config
    content {
      security_groups  = var.nc_security_groups == "" ? null : var.nc_security_groups
      subnets          = var.nc_subnets == "" ? null : var.nc_subnets
      assign_public_ip = var.nc_assign_public_ip == "" ? null : var.nc_assign_public_ip
    }
  }

  load_balancer {
    target_group_arn = aws_alb_target_group.service.arn
    container_name   = "${var.service_identifier}-${var.task_identifier}"
    container_port   = var.app_port
  }

  depends_on = [
    aws_alb_target_group.service,
    aws_alb_listener.service_https,
    aws_alb_listener.service_http,
    aws_iam_role.service,
  ]

  tags = local.default_tags
}

resource "aws_cloudwatch_log_group" "task" {
  name              = "${var.service_identifier}-${var.task_identifier}"
  retention_in_days = var.ecs_log_retention
}
