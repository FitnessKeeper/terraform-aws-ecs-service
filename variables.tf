variable "vpc_name" {
  type        = "string"
  description = "Name of VPC in which ECS cluster is located"
}

variable "ecs_cluster" {
  type        = "string"
  description = "Name of ECS cluster in which the service will be deployed"
}

variable "docker_image" {
  type        = "string"
  description = "Docker image to use for task"
}

variable "docker_memory" {
  description = "Hard limit on memory use for task container (default 256)"
  default     = "256"
}

variable "docker_memory_reservation" {
  description = "Soft limit on memory use for task container (default 128)"
  default     = "128"
}

variable "docker_port_mappings" {
  type        = "list"
  description = "List of port mapping maps of format { \"containerPort\": integer, [ \"hostPort\": integer, \"protocol\": \"tcp or udp\" ] }"
  default     = []
}

variable "docker_mount_points" {
  type        = "list"
  description = "List of mount point maps of format { \"sourceVolume\": \"vol_name\", \"containerPath\": \"path\", [\"readOnly\": \"true or false\" ] }"
  default     = []
}

variable "docker_environment" {
  type        = "list"
  description = "List of environment maps of format { \"name\": \"var_name\", \"value\": \"var_value\" }"
  default     = []
}

variable "network_mode" {
  description = "Docker network mode for task (default \"bridge\")"
  default     = "bridge"
}

variable "service_identifier" {
  description = "Unique identifier for this pganalyze service (used in log prefix, service name etc.)"
  default     = "service"
}

variable "task_identifier" {
  description = "Unique identifier for this pganalyze task (used in log prefix, service name etc.)"
  default     = "task"
}

variable "log_group_name" {
  type        = "string"
  description = "Name for CloudWatch Log Group that will receive collector logs (must be unique, default is created from service_identifier and task_identifier)"
  default     = ""
}

variable "extra_task_policy_arns" {
  type        = "list"
  description = "List of ARNs of IAM policies to be attached to the ECS task role (in addition to the default policy, so cannot be more than 9 ARNs)"
  default     = []
}

variable "acm_cert_domain" {
  type        = "string"
  description = "Domain name of ACM-managed certificate"
  default     = ""
}

variable "alb_enable_https" {
  description = "Enable HTTPS listener in ALB (default true)"
  default     = "true"
}

variable "alb_enable_http" {
  description = "Enable HTTP listener in ALB (default false)"
  default     = "false"
}

variable "alb_internal" {
  description = "Configure ALB as internal-only (default false)"
  default     = "false"
}

variable "alb_subnet_ids" {
  type        = "list"
  description = "VPC subnet IDs in which to create the ALB (unnecessary if neither alb_enable_https or alb_enable_http are true)"
  default     = []
}

variable "app_port" {
  type        = "string"
  description = "Numeric port on which application listens (unnecessary if neither alb_enable_https or alb_enable_http are true)"
  default     = ""
}

variable "ecs_placement_strategy_type" {
  description = "Placement strategy to use when distributing tasks (default binpack)"
  default     = "binpack"
}

variable "ecs_placement_strategy_field" {
  description = "Container metadata field to use when distributing tasks (default memory)"
  default     = "memory"
}

variable "ecs_log_retention" {
  description = "Number of days of ECS task logs to retain (default 3)"
  default     = 3
}

variable "alb_healthcheck_interval" {
  description = "Time in seconds between ALB health checks (default 30)"
  default     = 30
}

variable "alb_healthcheck_path" {
  description = "URI path for ALB health checks (default /)"
  default     = "/"
}

variable "alb_healthcheck_port" {
  description = "Port for ALB to use when connecting health checks (default same as application traffic)"
  default     = "traffic-port"
}

variable "alb_healthcheck_protocol" {
  description = "Protocol for ALB to use when connecting health checks (default HTTP)"
  default     = "HTTP"
}

variable "alb_healthcheck_timeout" {
  description = "Timeout in seconds for ALB to use when connecting health checks (default 5)"
  default     = 5
}

variable "alb_healthcheck_healthy_threshold" {
  description = "Number of consecutive successful health checks before marking service as healthy (default 5)"
  default     = 5
}

variable "alb_healthcheck_unhealthy_threshold" {
  description = "Number of consecutive failed health checks before marking service as unhealthy (default 2)"
  default     = 5
}

variable "alb_healthcheck_matcher" {
  description = "HTTP response codes to accept as healthy (default 200)"
  default     = "200"
}

variable "alb_stickiness_enabled" {
  description = "Enable ALB session stickiness (default false)"
  default     = "false"
}

variable "alb_cookie_duration" {
  description = "Duration of ALB session stickiness cookie in seconds (default 86400)"
  default     = "false"
}
