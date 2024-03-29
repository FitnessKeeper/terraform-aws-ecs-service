resource "aws_iam_role" "task" {
  name_prefix        = "${var.service_identifier}-${var.task_identifier}-ecsTaskRole"
  path               = "/${var.service_identifier}/"
  assume_role_policy = data.aws_iam_policy_document.assume_role_task.json

  tags = local.default_tags
}

resource "aws_iam_role_policy" "task" {
  name_prefix = "${var.service_identifier}-${var.task_identifier}-ecsTaskPolicy"
  role        = aws_iam_role.task.name
  policy      = data.aws_iam_policy_document.task_policy.json
}

resource "aws_iam_role" "service" {
  name_prefix        = "${var.service_identifier}-${var.task_identifier}-ecsServiceRole"
  path               = "/${var.service_identifier}/"
  assume_role_policy = data.aws_iam_policy_document.assume_role_service.json

  tags = local.default_tags
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

resource "aws_iam_role" "task_execution_role" {
  name               = "${var.service_identifier}-${var.task_identifier}-ecsTaskExecutionRole"
  assume_role_policy = data.aws_iam_policy_document.assume_role_task.json
  tags               = local.default_tags
}

resource "aws_iam_role_policy_attachment" "task-execution-role-policy-attachment" {
  role       = aws_iam_role.task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_iam_role_policy" "task_execution_role_policy" {
  name   = "${var.service_identifier}-${var.task_identifier}-ecs-task-execution-role-policy"
  role   = aws_iam_role.task_execution_role.id
  policy = data.aws_iam_policy_document.task_execution_role_policy.json
}

resource "aws_iam_role_policy_attachment" "ssm_instance_role_policy_payments" {
  role       = aws_iam_role.task.id
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}
