data "aws_acm_certificate" "alb" {
  count       = var.alb_enable_https ? 1 : 0
  domain      = var.acm_cert_domain
  most_recent = true
  statuses    = ["ISSUED"]
}

data "aws_security_group" "ecs" {
  id     = var.ecs_security_group_id
  vpc_id = data.aws_vpc.vpc.id
}

resource "aws_alb" "service" {
  count           = var.alb_enable_https || var.alb_enable_http ? 1 : 0
  name            = "${var.service_identifier}-${var.task_identifier}"
  internal        = var.alb_internal
  security_groups = [aws_security_group.alb[0].id]
  subnets         = var.alb_subnet_ids

  access_logs {
    enabled = var.lb_log_enabled
    bucket  = var.lb_bucket_name
    prefix  = coalesce(var.lb_prefix_override, "${var.lb_log_prefix}/${var.service_identifier}/${var.task_identifier}")
  }

  tags = var.tags
}

resource "aws_alb_listener" "service_https" {
  count             = var.alb_enable_https ? 1 : 0
  load_balancer_arn = aws_alb.service[0].arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2015-05"
  certificate_arn   = data.aws_acm_certificate.alb[0].arn

  default_action {
    target_group_arn = aws_alb_target_group.service.arn
    type             = "forward"
  }
}

resource "aws_alb_listener" "service_http" {
  count             = var.alb_enable_http ? 1 : 0
  load_balancer_arn = aws_alb.service[0].arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_alb_target_group.service.arn
    type             = "forward"
  }
}

resource "aws_alb_target_group" "service" {
  name                 = "${var.service_identifier}-${var.task_identifier}"
  port                 = var.app_port
  protocol             = "HTTP"
  deregistration_delay = var.alb_deregistration_delay
  vpc_id               = data.aws_vpc.vpc.id

  health_check {
    interval            = var.alb_healthcheck_interval
    path                = var.alb_healthcheck_path
    port                = var.alb_healthcheck_port
    protocol            = var.alb_healthcheck_protocol
    timeout             = var.alb_healthcheck_timeout
    healthy_threshold   = var.alb_healthcheck_healthy_threshold
    unhealthy_threshold = var.alb_healthcheck_unhealthy_threshold
    matcher             = var.alb_healthcheck_matcher
  }

  stickiness {
    enabled         = var.alb_stickiness_enabled
    type            = "lb_cookie"
    cookie_duration = var.alb_cookie_duration
  }

  tags = var.tags
}

resource "aws_security_group" "alb" {
  count       = var.alb_enable_https || var.alb_enable_http ? 1 : 0
  name_prefix = "alb-${var.service_identifier}-${var.task_identifier}-"
  description = "Security group for ${var.service_identifier}-${var.task_identifier} ALB"
  vpc_id      = data.aws_vpc.vpc.id

  tags = var.tags
}

resource "aws_security_group_rule" "alb_ingress_https" {
  count             = var.alb_enable_https ? 1 : 0
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = var.alb_sg_cidr
  security_group_id = aws_security_group.alb[0].id
}

resource "aws_security_group_rule" "alb_ingress_http" {
  count             = var.alb_enable_http ? 1 : 0
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = var.alb_sg_cidr
  security_group_id = aws_security_group.alb[0].id
}

resource "aws_security_group_rule" "alb_egress" {
  count             = var.alb_enable_https || var.alb_enable_http ? 1 : 0
  type              = "egress"
  from_port         = 0
  to_port           = 65535
  protocol          = "-1"
  cidr_blocks       = var.alb_sg_cidr_egress
  security_group_id = aws_security_group.alb[0].id
}
