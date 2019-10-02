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

resource "aws_iam_role" "task" {
  description        = "${var.service_identifier}-${var.task_identifier}-ecsTaskRole"
  path               = "/${var.service_identifier}/"
  assume_role_policy = data.aws_iam_policy_document.assume_role_task.json
}

resource "aws_iam_role_policy" "task" {
  role   = aws_iam_role.task.id
  policy = data.aws_iam_policy_document.task_policy.json
}

resource "aws_iam_role" "service" {
  description        = "${var.service_identifier}-${var.task_identifier}-ecsServiceRole"
  path               = "/${var.service_identifier}/"
  assume_role_policy = data.aws_iam_policy_document.assume_role_service.json
}

resource "aws_iam_role_policy_attachment" "service" {
  role       = aws_iam_role.service.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceRole"
}

resource "aws_iam_role_policy_attachment" "task_extra" {
  count      = length(var.extra_task_policy_arns)
  role       = aws_iam_role.task.name
  policy_arn = var.extra_task_policy_arns[count.index]
}

