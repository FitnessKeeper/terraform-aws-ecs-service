data "aws_region" "region" {
  region = var.region
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
    resources = concat([var.docker_secret], var.secret_arns)
  }

  dynamic "statement" {
    for_each = length(var.ssm_param_arns) > 0 ? [1] : []

    content {
      effect = "Allow"
      actions = [
        "ssm:GetParameter",
        "ssm:GetParameters"
      ]
      resources = var.ssm_param_arns
    }
  }

  dynamic "statement" {
    for_each = length(var.encryption_keys) > 0 ? [1] : []

    content {
      effect = "Allow"
      actions = [
        "kms:Decrypt"
      ]
      resources = var.encryption_keys
    }
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
