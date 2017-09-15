# ALB

data "aws_acm_certificate" "alb" {
  count = "${var.alb_enable_https ? 1 : 0}"
  domain = "${var.acm_cert_domain}"
  statuses = ["ISSUED"]
}

resource "aws_alb" "service" {
  count           = "${(var.alb_enable_https || var.alb_enable_http) ? 1 : 0}"
  name            = "${var.service_identifier}-${var.task_identifier}"
  internal        = "${var.alb_internal}"
  security_groups = ["${aws_security_group.alb.id}"]
  subnets         = ["${var.alb_subnet_ids}"]

  tags {
    VPC         = "${data.aws_vpc.vpc.tags["Name"]}"
    Application = "${aws_ecs_task_definition.task.family}"
  }
}

resource "aws_alb_listener" "service_https" {
  count             = "${var.alb_enable_https ? 1 : 0}"
  load_balancer_arn = "${aws_alb.service.arn}"
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2015-05"
  certificate_arn   = "${data.aws_acm_certificate.alb.arn}"

  default_action {
    target_group_arn = "${aws_alb_target_group.service.arn}"
    type             = "forward"
  }
}

resource "aws_alb_listener" "service_http" {
  count             = "${var.alb_enable_http ? 1 : 0}"
  load_balancer_arn = "${aws_alb.service.arn}"
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = "${aws_alb_target_group.service.arn}"
    type             = "forward"
  }
}

resource "aws_alb_target_group" "service" {
  count    = "${(var.alb_enable_https || var.alb_enable_http) ? 1 : 0}"
  name     = "${var.service_identifier}-${var.task_identifier}"
  port     = "${var.app_port}"
  protocol = "HTTP"
  vpc_id   = "${data.aws_vpc.vpc.id}"

  health_check {
    interval            = "${var.alb_healthcheck_interval}"
    path                = "${var.alb_healthcheck_path}"
    port                = "${var.alb_healthcheck_port}"
    protocol            = "${var.alb_healthcheck_protocol}"
    timeout             = "${var.alb_healthcheck_timeout}"
    healthy_threshold   = "${var.alb_healthcheck_healthy_threshold}"
    unhealthy_threshold = "${var.alb_healthcheck_unhealthy_threshold}"
    matcher             = "${var.alb_healthcheck_matcher}"
  }

  stickiness {
    enabled         = "${var.alb_stickiness_enabled}"
    type            = "lb_cookie"
    cookie_duration = "${var.alb_cookie_duration}"
  }

  tags {
    VPC         = "${data.aws_vpc.vpc.tags["Name"]}"
    Application = "${aws_ecs_task_definition.task.family}"
  }
}

resource "aws_security_group" "alb" {
  name_prefix = "alb-${var.service_identifier}-${var.task_identifier}-"
  description = "Security group for ${var.service_identifier}-${var.task_identifier} ALB"
  vpc_id      = "${data.aws_vpc.vpc.id}"

  tags {
    VPC         = "${data.aws_vpc.vpc.tags["Name"]}"
    Application = "${aws_ecs_task_definition.task.family}"
  }
}
