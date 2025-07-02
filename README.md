tf_aws_ecs_service
===========

Terraform module for deploying and managing a generic [ECS](https://aws.amazon.com/ecs/) service onto an existing cluster.

----------------------

## Usage

-----

```hcl

module "pganalyze_testdb" {
  source             = "github.com/terraform-community-modules/tf_aws_ecs_service?ref=v1.0.0"
  region             = "${data.aws_region.current.region}"
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

Authors
=======

* [Steve Huff](https://github.com/hakamadare)
* [Tim Hartmann](https://github.com/tfhartmann)

Changelog
=========

Please See the GitHub [Releases Page](https://github.com/FitnessKeeper/terraform-aws-ecs-service/releases)

License
=======

This software is released under the MIT License (see `LICENSE`).
----------------------

  
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| acm\_cert\_domain | Domain name of ACM-managed certificate | string | `""` | no |
| alb\_cookie\_duration | Duration of ALB session stickiness cookie in seconds (default 86400) | string | `"86400"` | no |
| alb\_deregistration\_delay | The amount of time in seconds to wait before deregistering a target from a target group (default) | string | `"300"` | no |
| alb\_enable\_http | Enable HTTP listener in ALB (default false) | string | `"false"` | no |
| alb\_enable\_https | Enable HTTPS listener in ALB (default true) | string | `"true"` | no |
| alb\_healthcheck\_healthy\_threshold | Number of consecutive successful health checks before marking service as healthy (default 5) | string | `"5"` | no |
| alb\_healthcheck\_interval | Time in seconds between ALB health checks (default 30) | string | `"30"` | no |
| alb\_healthcheck\_matcher | HTTP response codes to accept as healthy (default 200) | string | `"200"` | no |
| alb\_healthcheck\_path | URI path for ALB health checks (default /) | string | `"/"` | no |
| alb\_healthcheck\_port | Port for ALB to use when connecting health checks (default same as application traffic) | string | `"traffic-port"` | no |
| alb\_healthcheck\_protocol | Protocol for ALB to use when connecting health checks (default HTTP) | string | `"HTTP"` | no |
| alb\_healthcheck\_timeout | Timeout in seconds for ALB to use when connecting health checks (default 5) | string | `"5"` | no |
| alb\_healthcheck\_unhealthy\_threshold | Number of consecutive failed health checks before marking service as unhealthy (default 2) | string | `"5"` | no |
| alb\_internal | Configure ALB as internal-only (default false) | string | `"false"` | no |
| alb\_stickiness\_enabled | Enable ALB session stickiness (default false) | string | `"false"` | no |
| alb\_subnet\_ids | VPC subnet IDs in which to create the ALB (unnecessary if neither alb_enable_https or alb_enable_http are true) | list | `<list>` | no |
| app\_port | Numeric port on which application listens (unnecessary if neither alb_enable_https or alb_enable_http are true) | string | `""` | no |
| docker\_command | String to override CMD in Docker container (default "") | string | `""` | no |
| docker\_environment | List of environment maps of format { "name" = "var_name", "value" = "var_value" } | list | `<list>` | no |
| docker\_image | Docker image to use for task | string | n/a | yes |
| docker\_memory | Hard limit on memory use for task container (default 256) | string | `"256"` | no |
| docker\_memory\_reservation | Soft limit on memory use for task container (default 128) | string | `"128"` | no |
| docker\_mount\_points | List of mount point maps of format { "sourceVolume" = "vol_name", "containerPath" = "path", ["readOnly" = "true or false" ] } | list | `<list>` | no |
| docker\_port\_mappings | List of port mapping maps of format { "containerPort" = integer, [ "hostPort" = integer, "protocol" = "tcp or udp" ] } | list | `<list>` | no |
| ecs\_cluster\_arn | ARN of ECS cluster in which the service will be deployed | string | n/a | yes |
| ecs\_data\_volume\_path | Path to volume on ECS node to be defined as a "data" volume (default "/opt/data") | string | `"/opt/data"` | no |
| ecs\_deployment\_maximum\_percent | Upper limit in percentage of tasks that can be running during a deployment (default 200) | string | `"200"` | no |
| ecs\_deployment\_minimum\_healthy\_percent | Lower limit in percentage of tasks that must remain healthy during a deployment (default 100) | string | `"100"` | no |
| ecs\_desired\_count | Desired number of containers in the task (default 1) | string | `"1"` | no |
| ecs\_health\_check\_grace\_period | Seconds to ignore failing load balancer health checks on newly instantiated tasks to prevent premature shutdown, up to 1800. (default 0) | string | `"0"` | no |
| ecs\_log\_retention | Number of days of ECS task logs to retain (default 3) | string | `"3"` | no |
| ecs\_placement\_strategy\_field | Container metadata field to use when distributing tasks (default instanceId) | string | `"instanceId"` | no |
| ecs\_placement\_strategy\_type | Placement strategy to use when distributing tasks (default spread) | string | `"spread"` | no |
| ecs\_security\_group\_id | Security group ID of ECS cluster in which the service will be deployed | string | n/a | yes |
| extra\_task\_policy\_arns | List of ARNs of IAM policies to be attached to the ECS task role (in addition to the default policy, so cannot be more than 9 ARNs) | list | `<list>` | no |
| lb\_bucket\_name | Full name for S3 bucket. | string | n/a | yes |
| lb\_log\_enabled | Enables/Disables logging to designated S3 bucket.  S3 bucket name (lb_bucket_name) is still required.  (default is true) | string | `"true"` | no |
| lb\_log\_prefix | Prefix for S3 bucket. (default is log/elb). | string | `"logs/elb"` | no |
| log\_group\_name | Name for CloudWatch Log Group that will receive collector logs (must be unique, default is created from service_identifier and task_identifier) | string | `""` | no |
| network\_mode | Docker network mode for task (default "bridge") | string | `"bridge"` | no |
| region | AWS region in which ECS cluster is located (default is 'us-east-1') | string | `"us-east-1"` | no |
| service\_identifier | Unique identifier for this pganalyze service (used in log prefix, service name etc.) | string | `"service"` | no |
| task\_identifier | Unique identifier for this pganalyze task (used in log prefix, service name etc.) | string | `"task"` | no |
| vpc\_id | ID of VPC in which ECS cluster is located | string | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| alb\_arn | ARN of ALB provisioned for service (if present) |
| alb\_dns\_name | FQDN of ALB provisioned for service (if present) |
| alb\_zone\_id | Route 53 zone ID of ALB provisioned for service (if present) |
| log\_group\_arn | ARN of the CloudWatch Log Group |
| log\_group\_name | Name of the CloudWatch Log Group |
| service\_iam\_role\_arn | ARN of the IAM Role for the ECS Service |
| service\_iam\_role\_name | Name of the IAM Role for the ECS Task |
| task\_iam\_role\_arn | ARN of the IAM Role for the ECS Task |
| task\_iam\_role\_name | Name of the IAM Role for the ECS Task |
