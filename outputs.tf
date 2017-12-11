output "alb_dns_name" {
  description = "FQDN of ALB provisioned for service (if present)"
  value       = "${(var.alb_enable_https || var.alb_enable_http) ? element(concat(aws_alb.service.*.dns_name, list("")), 0) : "not created"}"
}

output "alb_zone_id" {
  description = "Route 53 zone ID of ALB provisioned for service (if present)"
  value       = "${(var.alb_enable_https || var.alb_enable_http) ? element(concat(aws_alb.service.*.zone_id, list("")), 0) : "not created"}"
}
