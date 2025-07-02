variable "region" {
  type        = string
  description = "AWS region in which ECS cluster is located (default is 'us-east-1')"
  default     = "us-east-1"
}

variable "env" {
  type        = string
  description = "Environment of an application"
}

variable "vpc_id" {
  type        = string
  description = "ID of VPC in which ECS cluster is located"
}

variable "ecs_cluster_arn" {
  type        = string
  description = "ARN of ECS cluster in which the service will be deployed"
}

variable "ecs_desired_count" {
  type        = string
  description = "Desired number of containers in the task (default 1)"
  default     = 1
}

variable "ecs_deployment_maximum_percent" {
  description = "Upper limit in percentage of tasks that can be running during a deployment (default 200)"
  type        = string
  default     = "200"
}

variable "ecs_deployment_minimum_healthy_percent" {
  description = "Lower limit in percentage of tasks that must remain healthy during a deployment (default 100)"
  type        = string
  default     = "100"
}

variable "deployment_controller_type" {
  description = "Type of deployment controller. Valid values: CODE_DEPLOY, ECS. Default: ECS."
  type        = string
  default     = "ECS"
}

variable "ecs_health_check_grace_period" {
  description = "Seconds to ignore failing load balancer health checks on newly instantiated tasks to prevent premature shutdown, up to 1800. (default 0)"
  type        = number
  default     = 0
}

variable "docker_command" {
  description = "String to override CMD in Docker container (default \"\")"
  type        = string
  default     = ""
}

variable "docker_image" {
  type        = string
  description = "Docker image to use for task"
}

variable "docker_memory" {
  description = "Hard limit on memory use for task container (default 256)"
  type        = number
  default     = 256
}

variable "docker_memory_reservation" {
  description = "Soft limit on memory use for task container (default 128)"
  type        = number
  default     = 128
}

variable "docker_environment" {
  description = "List of environment maps of format { \"name\" = \"var_name\", \"value\" = \"var_value\" }"
  type        = list(any)
  default     = []
}

variable "network_mode" {
  description = "Docker network mode for task (default \"bridge\")"
  type        = string
  default     = "bridge"
}

variable "req_compatibilities" {
  description = "Launch type required by the task. Either EC2 or FARGATE"
  type        = list(string)
  default     = ["FARGATE"]
}

variable "cpu" {
  description = "Number of cpu units used by the task. Required for FARGATE type"
  type        = number
  default     = null
}

variable "memory" {
  description = "Amount (in MiB) of memory used by the task. Required for FARGATE type"
  type        = number
  default     = null
}

variable "service_identifier" {
  description = "Unique identifier for this pganalyze service (used in log prefix, service name etc.)"
  type        = string
}

variable "task_identifier" {
  description = "Unique identifier for this pganalyze task (used in log prefix, service name etc.)"
  type        = string
  default     = "task"
}

variable "extra_task_policy_arns" {
  type        = list(string)
  description = "List of ARNs of IAM policies to be attached to the ECS task role (in addition to the default policy, so cannot be more than 9 ARNs)"
  default     = []
}

variable "acm_cert_domain" {
  type        = string
  description = "Domain name of ACM-managed certificate"
  default     = null
}

variable "alb_enable_https" {
  description = "Enable HTTPS listener in ALB (default true)"
  type        = bool
  default     = "true"
}

variable "alb_enable_http" {
  description = "Enable HTTP listener in ALB (default false)"
  type        = bool
  default     = false
}

variable "alb_sg_cidr" {
  description = "List of CIDR blocks for ALB SG, default [\"0.0.0.0/0\"]"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "alb_sg_cidr_egress" {
  description = "List of CIDR blocks for ALB SG, default [\"0.0.0.0/0\"]"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "alb_internal" {
  description = "Configure ALB as internal-only (default false)"
  type        = bool
  default     = false
}

variable "alb_subnet_ids" {
  type        = list(string)
  description = "VPC subnet IDs in which to create the ALB (unnecessary if neither alb_enable_https or alb_enable_http are true)"
  default     = []
}

variable "target_type" {
  description = "Type of target that you must specify when registering targets with this target group"
  type        = string
  default     = "instance"
}

variable "app_port" {
  description = "Numeric port on which application listens (unnecessary if neither alb_enable_https or alb_enable_http are true)"
  type        = number
}

variable "host_port" {
  description = "Numeric port on which you want to map it to on the host"
  type        = number
  default     = 0
}

variable "ecs_placement_strategy_type" {
  description = "Placement strategy to use when distributing tasks (default spread)"
  type        = string
  default     = "spread"
}

variable "ecs_placement_strategy_field" {
  description = "Container metadata field to use when distributing tasks (default instanceId)"
  type        = string
  default     = "instanceId"
}

variable "ecs_log_retention" {
  description = "Number of days of ECS task logs to retain (default 3)"
  type        = number
  default     = 3
}

variable "lb_log_enabled" {
  description = "Enables/Disables logging to designated S3 bucket.  S3 bucket name (lb_bucket_name) is still required.  (default is true)"
  type        = bool
  default     = true
}

variable "lb_bucket_name" {
  description = "Full name for S3 bucket."
  type        = string
}

variable "lb_prefix_override" {
  type    = string
  default = null
}

variable "lb_log_prefix" {
  description = "Prefix for S3 bucket. (default is log/elb)."
  type        = string
  default     = "logs/elb"
}

variable "alb_healthcheck_interval" {
  description = "Time in seconds between ALB health checks (default 30)"
  type        = number
  default     = 30
}

variable "alb_healthcheck_path" {
  description = "URI path for ALB health checks (default /)"
  type        = string
  default     = "/"
}

variable "alb_healthcheck_port" {
  description = "Port for ALB to use when connecting health checks (default same as application traffic)"
  type        = string
  default     = "traffic-port"
}

variable "alb_healthcheck_protocol" {
  description = "Protocol for ALB to use when connecting health checks (default HTTP)"
  type        = string
  default     = "HTTP"
}

variable "alb_healthcheck_timeout" {
  description = "Timeout in seconds for ALB to use when connecting health checks (default 5)"
  type        = number
  default     = 5
}

variable "alb_healthcheck_healthy_threshold" {
  description = "Number of consecutive successful health checks before marking service as healthy (default 5)"
  type        = number
  default     = 5
}

variable "alb_healthcheck_unhealthy_threshold" {
  description = "Number of consecutive failed health checks before marking service as unhealthy (default 2)"
  type        = number
  default     = 5
}

variable "alb_healthcheck_matcher" {
  description = "HTTP response codes to accept as healthy (default 200)"
  type        = string
  default     = "200"
}

variable "alb_stickiness_enabled" {
  description = "Enable ALB session stickiness (default false)"
  type        = string
  default     = "false"
}

variable "alb_cookie_duration" {
  description = "Duration of ALB session stickiness cookie in seconds (default 86400)"
  type        = string
  default     = "86400"
}

variable "alb_deregistration_delay" {
  description = "The amount of time in seconds to wait before deregistering a target from a target group."
  type        = string
  default     = "300"
}

variable "network_config" {
  description = "Applicable when networkmode is fargate"
  type = list(object({
    security_groups  = optional(list(string))
    subnets          = optional(list(string))
    assign_public_ip = optional(bool)
  }))
  default = []
}

variable "task_volume" {
  description = "optional volume block in task definition. Do not pass any value for FARGATE launch type"
  type = list(object({
    name      = string
    host_path = optional(string)
  }))
  default = []
}

variable "launch_type" {
  description = "Launch type on which to run the service. Default is EC2"
  type        = string
  default     = "FARGATE"
}

variable "placement_strategy" {
  type = list(object({
    type  = string
    field = optional(string)
  }))
}

variable "docker_secret" {
  description = "arn of the secret to be used for dockerhub authentication"
  type        = string
  default     = ""
}

variable "enable_exec" {
  description = "Whether enable exec command on the task or not"
  type        = bool
  default     = false
}

variable "entrypoint" {
  description = "The entry point that's passed to the container."
  type        = list(string)
  default     = []
}

variable "secrets" {
  description = "Secrets to be passed to the container environment"
  type        = list(any)
  default     = null
}

variable "secret_arns" {
  description = "Arn of the secrets that are passed to the container environment"
  type        = list(string)
  default     = null
}

variable "encryption_keys" {
  description = "Kms key to decrypt secrets"
  type        = list(string)
  default     = []
}

variable "ssm_param_arns" {
  description = "Arn of the ssm parameters that are passed to the container environment"
  type        = list(string)
  default     = []
}

variable "create_alb" {
  description = "Whether to create ALB and related resources"
  type        = bool
  default     = true
}
