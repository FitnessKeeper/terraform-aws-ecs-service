tf_aws_ecs_service
===========

Terraform module for deploying and managing a generic [ECS](https://aws.amazon.com/ecs/) service onto an existing cluster.

----------------------
#### Required
- `region` - AWS region in which the EC2 Container Service cluster is located
- `ecs_cluster` - EC2 Container Service cluster in which the service will be deployed (must already exist, the module will not create it).
- `service_identifier` - Unique identifier for the service, used in naming resources.
- `task_identifier` - Unique identifier for the task, used in naming resources.
- `docker_image` - Docker image specification.
- `vpc_id` - ID of VPC in which ECS cluster is located
- `ecs_cluster_arn` - ARN of ECS cluster in which the service will be deployed
- `ecs_security_group_id` - Security group ID of ECS cluster in which the service will be deployed

#### Optional

- `ecs_desired_count` - Desired number of containers in the task (default 1)
- `docker_command` - String to override CMD in Docker container (default "")
- `docker_memory` - Hard limit on memory use for task container (default 256)
- `docker_memory_reservation` - Soft limit on memory use for task container (default 128)
- `docker_port_mappings` - List of port mapping maps of format `{ "containerPort" = integer, [ "hostPort" = integer, "protocol" = "tcp or udp" ] }` (default [])
- `docker_mount_points` -  List of mount point maps of format `{ "sourceVolume" = "vol_name", "containerPath" = "path", ["readOnly" = "true or false" ] }` (default [])
- `ecs_data_volume_path` - Path to volume on ECS node to be defined as a "data" volume (default "/opt/data")"
- `docker_environment` - List of environment maps of format `{ "name" = "var_name", "value" = "var_value" }` (default [])
- `network_mode` - Docker network mode for task (default "bridge")
- `log_group_name` - Name for CloudWatch Log Group that will receive collector logs (must be unique, default is created from service_identifier and task_identifier)
- `extra_task_policy_arns` - List of ARNs of IAM policies to be attached to the ECS task role (in addition to the default policy, so cannot be more than 9 ARNs)
- `acm_cert_domain` - Domain name of ACM-managed certificate
- `alb_enable_https` - Enable HTTPS listener in ALB (default true)
- `alb_enable_http` - Enable HTTP listener in ALB (default false)
- `alb_internal` - Configure ALB as internal-only (default false)
- `alb_subnet_ids` - VPC subnet IDs in which to create the ALB (unnecessary if neither alb_enable_https or alb_enable_http are true)
- `app_port` - Numeric port on which application listens (unnecessary if neither alb_enable_https or alb_enable_http are true)
- `ecs_deployment_maximum_percent` - Upper limit in percentage of tasks that can be running during a deployment (default 200)
- `ecs_deployment_minimum_healthy_percent` - Lower limit in percentage of tasks that must remain healthy during a deployment (default 100)
- `ecs_placement_strategy_type` - Placement strategy to use when distributing tasks (default binpack)
- `ecs_placement_strategy_field` - Container metadata field to use when distributing tasks (default memory)
- `ecs_log_retention` - Number of days of ECS task logs to retain (default 3)
- `alb_healthcheck_interval` - Time in seconds between ALB health checks (default 30)
- `alb_healthcheck_path` - URI path for ALB health checks (default /)
- `alb_healthcheck_port` - Port for ALB to use when connecting health checks (default same as application traffic)
- `alb_healthcheck_protocol - Protocol for ALB to use when connecting health checks (default HTTP)
- `alb_healthcheck_timeout` - Timeout in seconds for ALB to use when connecting health checks (default 5)
- `alb_healthcheck_healthy_threshold` - Number of consecutive successful health checks before marking service as healthy (default 5)
- `alb_healthcheck_unhealthy_threshold` - Number of consecutive failed health checks before marking service as unhealthy (default 2)
- `alb_healthcheck_matcher` - HTTP response codes to accept as healthy (default 200)
- `alb_stickiness_enabled` - Enable ALB session stickiness (default false)
- `alb_cookie_duration` - Duration of ALB session stickiness cookie in seconds (default 86400)

Usage
-----

```hcl

module "pganalyze_testdb" {
  source             = "github.com/terraform-community-modules/tf_aws_ecs_service?ref = v1.0.0"
  region             = "${data.aws_region.current.name}"
  ecs_cluster        = "my-ecs-cluster"
  service_identifier = "pganalyze"
  task_identifier    = "testdb"
  docker_image       = "quay.io/pganalyze:stable"

  docker_environment = [
    {
      "name"  = "DB_URL",
      "value" = "postgres://user:password@host:port/database",
    },
  ]
}
```

Outputs
=======

FIXME there are some outputs

Authors
=======

* [Steve Huff](https://github.com/hakamadare)
* [Tim Hartmann](https://github.com/tfhartmann)

Changelog
=========

2.1.0 - IAM role outputs.

1.0.0 - Initial release.

License
=======

This software is released under the MIT License (see `LICENSE`).
