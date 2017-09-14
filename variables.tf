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
