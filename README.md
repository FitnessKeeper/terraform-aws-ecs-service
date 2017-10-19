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

#### Optional
- `aws_profile` - AWS config profile to use (default `default`)

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
None.

Authors
=======

[Steve Huff](https://github.com/hakamadare)

Changelog
=========

1.0.0 - Initial release.

License
=======

This software is released under the MIT License (see `LICENSE`).
