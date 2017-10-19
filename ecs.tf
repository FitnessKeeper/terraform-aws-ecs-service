# ECS SERVICE

data "template_file" "container_definition" {
  template = "${file("${path.module}/files/container_definition.json")}"

  vars {
    service_identifier    = "${var.service_identifier}"
    task_identifier       = "${var.task_identifier}"
    image                 = "${var.docker_image}"
    memory                = "${var.docker_memory}"
    memory_reservation    = "${var.docker_memory_reservation}"
    app_port              = "${var.app_port}"
    environment           = "${jsonencode(var.docker_environment)}"
    mount_points          = "${jsonencode(var.docker_mount_points)}"
    awslogs_region        = "${data.aws_region.region.name}"
    awslogs_group         = "${var.service_identifier}-${var.task_identifier}"
    awslogs_region        = "${data.aws_region.region.name}"
    awslogs_stream_prefix = "${var.service_identifier}"
  }
}

resource "aws_ecs_task_definition" "task" {
  provider              = "aws.provided"
  family                = "${var.service_identifier}-${var.task_identifier}"
  container_definitions = "${data.template_file.container_definition.rendered}"
  network_mode          = "${var.network_mode}"
  task_role_arn         = "${aws_iam_role.task.arn}"
}

resource "aws_ecs_service" "service" {
  provider        = "aws.provided"
  name            = "${var.service_identifier}-${var.task_identifier}-service"
  cluster         = "${var.ecs_cluster_arn}"
  task_definition = "${aws_ecs_task_definition.task.arn}"
  desired_count   = "${var.ecs_desired_count}"
  iam_role        = "${aws_iam_role.service.arn}"

  placement_strategy {
    type  = "${var.ecs_placement_strategy_type}"
    field = "${var.ecs_placement_strategy_field}"
  }

  load_balancer {
    target_group_arn = "${aws_alb_target_group.service.arn}"
    container_name   = "${var.service_identifier}-${var.task_identifier}"
    container_port   = "${var.app_port}"
  }

  depends_on = [
    "aws_alb_target_group.service",
    "aws_alb_listener.service_https",
    "aws_alb_listener.service_http",
    "aws_iam_role.service",
  ]
}

resource "aws_cloudwatch_log_group" "task" {
  provider          = "aws.provided"
  name              = "${var.service_identifier}-${var.task_identifier}"
  retention_in_days = "${var.ecs_log_retention}"
}
