tf_aws_ecs_service
===========

Terraform module for deploying and managing a generic [ECS](https://aws.amazon.com/ecs/) service onto an existing cluster.

----------------------

## Required Inputs

The following input variables are required:

### docker\_image

Description: Docker image to use for task

Type: `string`

### ecs\_cluster\_arn

Description: ARN of ECS cluster in which the service will be deployed

Type: `string`

### ecs\_security\_group\_id

Description: Security group ID of ECS cluster in which the service will be deployed

Type: `string`

### lb\_bucket\_name

Description: Full name for S3 bucket.

Type: `string`

### vpc\_id

Description: ID of VPC in which ECS cluster is located

Type: `string`

## Optional Inputs

The following input variables are optional (have default values):

### acm\_cert\_domain

Description: Domain name of ACM-managed certificate

Type: `string`

Default: `""`

### alb\_cookie\_duration

Description: Duration of ALB session stickiness cookie in seconds (default 86400)

Type: `string`

Default: `"86400"`

### alb\_enable\_http

Description: Enable HTTP listener in ALB (default false)

Type: `string`

Default: `"false"`

### alb\_enable\_https

Description: Enable HTTPS listener in ALB (default true)

Type: `string`

Default: `"true"`

### alb\_healthcheck\_healthy\_threshold

Description: Number of consecutive successful health checks before marking service as healthy (default 5)

Type: `string`

Default: `"5"`

### alb\_healthcheck\_interval

Description: Time in seconds between ALB health checks (default 30)

Type: `string`

Default: `"30"`

### alb\_healthcheck\_matcher

Description: HTTP response codes to accept as healthy (default 200)

Type: `string`

Default: `"200"`

### alb\_healthcheck\_path

Description: URI path for ALB health checks (default /)

Type: `string`

Default: `"/"`

### alb\_healthcheck\_port

Description: Port for ALB to use when connecting health checks (default same as application traffic)

Type: `string`

Default: `"traffic-port"`

### alb\_healthcheck\_protocol

Description: Protocol for ALB to use when connecting health checks (default HTTP)

Type: `string`

Default: `"HTTP"`

### alb\_healthcheck\_timeout

Description: Timeout in seconds for ALB to use when connecting health checks (default 5)

Type: `string`

Default: `"5"`

### alb\_healthcheck\_unhealthy\_threshold

Description: Number of consecutive failed health checks before marking service as unhealthy (default 2)

Type: `string`

Default: `"5"`

### alb\_internal

Description: Configure ALB as internal-only (default false)

Type: `string`

Default: `"false"`

### alb\_stickiness\_enabled

Description: Enable ALB session stickiness (default false)

Type: `string`

Default: `"false"`

### alb\_subnet\_ids

Description: VPC subnet IDs in which to create the ALB (unnecessary if neither alb_enable_https or alb_enable_http are true)

Type: `list`

Default: `<list>`

### app\_port

Description: Numeric port on which application listens (unnecessary if neither alb_enable_https or alb_enable_http are true)

Type: `string`

Default: `""`

### docker\_command

Description: String to override CMD in Docker container (default "")

Type: `string`

Default: `""`

### docker\_environment

Description: List of environment maps of format { "name" = "var_name", "value" = "var_value" }

Type: `list`

Default: `<list>`

### docker\_memory

Description: Hard limit on memory use for task container (default 256)

Type: `string`

Default: `"256"`

### docker\_memory\_reservation

Description: Soft limit on memory use for task container (default 128)

Type: `string`

Default: `"128"`

### docker\_mount\_points

Description: List of mount point maps of format { "sourceVolume" = "vol_name", "containerPath" = "path", ["readOnly" = "true or false" ] }

Type: `list`

Default: `<list>`

### docker\_port\_mappings

Description: List of port mapping maps of format { "containerPort" = integer, [ "hostPort" = integer, "protocol" = "tcp or udp" ] }

Type: `list`

Default: `<list>`

### ecs\_data\_volume\_path

Description: Path to volume on ECS node to be defined as a "data" volume (default "/opt/data")

Type: `string`

Default: `"/opt/data"`

### ecs\_deployment\_maximum\_percent

Description: Upper limit in percentage of tasks that can be running during a deployment (default 200)

Type: `string`

Default: `"200"`

### ecs\_deployment\_minimum\_healthy\_percent

Description: Lower limit in percentage of tasks that must remain healthy during a deployment (default 100)

Type: `string`

Default: `"100"`

### ecs\_desired\_count

Description: Desired number of containers in the task (default 1)

Type: `string`

Default: `"1"`

### ecs\_health\_check\_grace\_period

Description: Seconds to ignore failing load balancer health checks on newly instantiated tasks to prevent premature shutdown, up to 1800. (default 0)

Type: `string`

Default: `"0"`

### ecs\_log\_retention

Description: Number of days of ECS task logs to retain (default 3)

Type: `string`

Default: `"3"`

### ecs\_placement\_strategy\_field

Description: Container metadata field to use when distributing tasks (default memory)

Type: `string`

Default: `"memory"`

### ecs\_placement\_strategy\_type

Description: Placement strategy to use when distributing tasks (default binpack)

Type: `string`

Default: `"binpack"`

### extra\_task\_policy\_arns

Description: List of ARNs of IAM policies to be attached to the ECS task role (in addition to the default policy, so cannot be more than 9 ARNs)

Type: `list`

Default: `<list>`

### lb\_log\_enabled

Description: Enables/Disables logging to designated S3 bucket.  S3 bucket name (lb_bucket_name) is still required.  (default is true)

Type: `string`

Default: `"true"`

### lb\_log\_prefix

Description: Prefix for S3 bucket. (default is log/elb).

Type: `string`

Default: `"logs/elb"`

### log\_group\_name

Description: Name for CloudWatch Log Group that will receive collector logs (must be unique, default is created from service_identifier and task_identifier)

Type: `string`

Default: `""`

### network\_mode

Description: Docker network mode for task (default "bridge")

Type: `string`

Default: `"bridge"`

### region

Description: AWS region in which ECS cluster is located (default is 'us-east-1')

Type: `string`

Default: `"us-east-1"`

### service\_identifier

Description: Unique identifier for this pganalyze service (used in log prefix, service name etc.)

Type: `string`

Default: `"service"`

### task\_identifier

Description: Unique identifier for this pganalyze task (used in log prefix, service name etc.)

Type: `string`

Default: `"task"`

## Outputs

The following outputs are exported:

### alb\_dns\_name

Description: FQDN of ALB provisioned for service (if present)

### alb\_zone\_id

Description: Route 53 zone ID of ALB provisioned for service (if present)

### log\_group\_arn

Description: ARN of the CloudWatch Log Group

### log\_group\_name

Description: Name of the CloudWatch Log Group

### service\_iam\_role\_arn

Description: ARN of the IAM Role for the ECS Service

### service\_iam\_role\_name

Description: Name of the IAM Role for the ECS Task

### task\_iam\_role\_arn

Description: ARN of the IAM Role for the ECS Task

### task\_iam\_role\_name

Description: Name of the IAM Role for the ECS Task

## Usage

-----

```hcl

module "pganalyze_testdb" {
  source             = "github.com/terraform-community-modules/tf_aws_ecs_service?ref=v1.0.0"
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
