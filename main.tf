data "aws_ecs_cluster" "ecs" {
  cluster_name = "${var.ecs_cluster}"
}

data "aws_region" "current" {
  current = true
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
    awslogs_group         = "${length(var.log_group) > 0 ? var.log_group : task_identifier}"
    awslogs_region        = "${data.aws_region.current.name}"
    awslogs_stream_prefix = "${service_identifier}"
  }
}

resource "aws_ecs_task_definition" "task" {
  family                = "${var.service_identifier}-${var.task_identifier}"
  container_definitions = "${data.template_file.container_definitions.rendered}"
  network_mode          = "${var.network_mode}"
  task_role_arn         = "${aws_iam_role.pganalyze_task.arn}"
}

resource "aws_ecs_service" "service" {
  name            = "${var.service_identifier}-${var.task_identifier}"
  cluster         = "${data.aws_ecs_cluster.ecs.id}"
  task_definition = "${aws_ecs_task_definition.pganalyze.arn}"
  desired_count   = 1

  placement_strategy {
    type  = "binpack"
    field = "memory"
  }
}
