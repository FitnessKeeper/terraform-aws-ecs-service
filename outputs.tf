output "alb_dns_name" {
  description = "FQDN of ALB provisioned for service (if present)"
  value       = var.alb_enable_https || var.alb_enable_http ? element(concat(aws_alb.service[*].dns_name, [""]), 0) : "not created"
}

output "alb_arn" {
  description = "ARN of ALB provisioned for service (if present)"
  value       = var.alb_enable_https || var.alb_enable_http ? element(concat(aws_alb.service[*].arn, [""]), 0) : "not created"
}

output "alb_zone_id" {
  description = "Route 53 zone ID of ALB provisioned for service (if present)"
  value       = var.alb_enable_https || var.alb_enable_http ? element(concat(aws_alb.service[*].zone_id, [""]), 0) : "not created"
}

output "alb_https_listener_arn" {
  description = "ARN of the HTTPS Listener (if present)"
  value       = var.create_alb && var.alb_enable_https ? aws_alb_listener.service_https[0].arn : "not created"
}

output "target_group_arn" {
  description = "ARN of the target group provisioned for service"
  value       = aws_alb_target_group.service.arn
}

output "task_iam_role_arn" {
  description = "ARN of the IAM Role for the ECS Task"
  value       = aws_iam_role.task.arn
}

output "task_iam_role_name" {
  description = "Name of the IAM Role for the ECS Task"
  value       = aws_iam_role.task.name
}

output "service_iam_role_arn" {
  description = "ARN of the IAM Role for the ECS Service"
  value       = aws_iam_role.service.arn
}

output "service_iam_role_name" {
  description = "Name of the IAM Role for the ECS Task"
  value       = aws_iam_role.service.name
}

output "log_group_name" {
  description = "Name of the CloudWatch Log Group"
  value       = aws_cloudwatch_log_group.task.name
}

output "log_group_arn" {
  description = "ARN of the CloudWatch Log Group"
  value       = aws_cloudwatch_log_group.task.arn
}

output "alb_sg_id" {
  description = "Load balancer security group id"
  value       = var.create_alb ? aws_security_group.alb[0].id : "not created by module"
}
