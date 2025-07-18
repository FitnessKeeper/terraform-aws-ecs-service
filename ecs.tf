resource "aws_ecs_task_definition" "task" {
  family = "${var.service_identifier}-${var.task_identifier}"
  container_definitions = jsonencode([{
    name  = "${var.service_identifier}-${var.task_identifier}"
    image = var.docker_image
    repositoryCredentials = {
      credentialsParameter = var.docker_secret
    }
    memory            = var.docker_memory
    cpu               = var.cpu
    essential         = true
    memoryReservation = var.docker_memory_reservation
    linuxParameters   = local.docker_linux_params
    systemControls    = []
    entrypoint        = var.entrypoint
    portMappings = [{
      containerPort = var.app_port
      hostPort      = var.host_port
      protocol      = "tcp"
    }]
    command     = length(var.docker_command) > 0 ? var.docker_command : null
    environment = var.docker_environment
    mountPoints = length(var.task_volume) > 0 ? [{
      sourceVolume  = var.task_volume[0].name
      containerPath = var.task_volume[0].host_path
    }] : []
    volumesFrom = []
    logConfiguration = {
      logDriver = "awslogs"
      options = {
        "awslogs-group"         = aws_cloudwatch_log_group.task.name
        "awslogs-region"        = data.aws_region.region.region
        "awslogs-stream-prefix" = var.service_identifier
      }
    }
    secrets = length(var.secrets) > 0 ? var.secrets : null
  }])

  network_mode             = var.network_mode
  requires_compatibilities = var.req_compatibilities
  cpu                      = var.cpu
  memory                   = var.memory
  execution_role_arn       = aws_iam_role.task_execution_role.arn
  task_role_arn            = aws_iam_role.task.arn

  dynamic "volume" {
    for_each = var.task_volume
    content {
      name = length(var.task_volume) == 0 ? null : var.task_volume[0].name
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
  enable_execute_command             = var.enable_exec

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
      security_groups  = network_configuration.value.security_groups
      subnets          = network_configuration.value.subnets
      assign_public_ip = network_configuration.value.assign_public_ip
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

  propagate_tags = "SERVICE"
  tags           = local.default_tags
}

resource "aws_cloudwatch_log_group" "task" {
  name              = "${var.service_identifier}-${var.task_identifier}"
  retention_in_days = var.ecs_log_retention
}
