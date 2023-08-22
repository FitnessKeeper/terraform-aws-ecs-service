data "aws_region" "region" {
  name = var.region
}

data "aws_vpc" "vpc" {
  id = var.vpc_id
}

# ALB data sources
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

# IAM data sources
data "aws_iam_policy_document" "task_policy" {
  statement {
    actions = [
      "ec2:Describe*",
      "autoscaling:Describe*",
      "ec2:DescribeAddresses",
      "ec2:DescribeInstances",
      "ec2:DescribeTags",
    ]

    resources = ["*"]
  }

  statement {
    actions = [
      "cloudwatch:GetMetricStatistics",
      "logs:DescribeLogStreams",
      "logs:CreateLogStream",
      "logs:GetLogEvents",
      "logs:PutLogEvents",
    ]

    resources = [
      "*",
    ]
  }
}

data "aws_iam_policy_document" "assume_role_task" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "assume_role_service" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "task_execution_role_policy" {
  statement {
    effect    = "Allow"
    actions   = ["secretsmanager:GetSecretValue"]
    resources = ["${var.docker_secret}"]
  }

  statement {
    effect = "Allow"
    actions = [
      "ecs:ExecuteCommand",
      "ecs:DescribeTasks"
    ]
    resources = [aws_ecs_task_definition.task.arn]
  }
}
