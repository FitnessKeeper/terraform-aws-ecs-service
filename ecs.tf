# ECS SERVICE

data "aws_ecs_cluster" "ecs" {
  cluster_name = "${var.ecs_cluster}"
}

data "template_file" "container_definitions" {
  template = "${file("${path.module}/files/container_definitions.json")}"

  vars {
    service_identifier    = "${var.service_identifier}"
    task_identifier       = "${var.task_identifier}"
    image                 = "${var.docker_image}"
    memory                = "${var.docker_memory}"
    memory_reservation    = "${var.docker_memory_reservation}"
    port_mappings         = ["${var.docker_port_mappings}"]
    environment           = ["${var.docker_environment}"]
    mount_points          = ["${var.docker_mount_points}"]
    awslogs_region        = "${data.aws_region.current.name}"
    awslogs_group         = "${aws_cloudwatch_log_group.task.arn}"
    awslogs_region        = "${data.aws_region.current.name}"
    awslogs_stream_prefix = "${var.service_identifier}"
  }
}

resource "aws_ecs_task_definition" "task" {
  family                = "${var.service_identifier}-${var.task_identifier}"
  container_definitions = "${data.template_file.container_definitions.rendered}"
  network_mode          = "${var.network_mode}"
  task_role_arn         = "${aws_iam_role.task.arn}"
}

resource "aws_ecs_service" "service" {
  name            = "${var.service_identifier}-${var.task_identifier}"
  cluster         = "${data.aws_ecs_cluster.ecs.id}"
  task_definition = "${aws_ecs_task_definition.task.arn}"
  desired_count   = "${var.ecs_desired_count}"

  placement_strategy {
    type  = "${var.ecs_placement_strategy_type}"
    field = "${var.ecs_placement_strategy_field}"
  }
}

resource "aws_cloudwatch_log_group" "task" {
  name_prefix       = "${var.task_identifier}-"
  retention_in_days = "${var.ecs_log_retention}"

  tags {
    Application = "${aws_ecs_task_definition.task.family}"
  }
}
