resource "aws_ecs_cluster" "ecs_cluster" {
    name = var.ecs_cluster_config.cluster_name
}

resource "aws_ecs_cluster_capacity_providers" "capacity_provider_association" {
  cluster_name = aws_ecs_cluster.ecs_cluster.name
  capacity_providers = [aws_ecs_capacity_provider.capacity_provider.name]

  default_capacity_provider_strategy {
    capacity_provider = aws_ecs_capacity_provider.capacity_provider.name
    weight            = 1
    base              = 0
  }

  
}

resource "aws_ecs_capacity_provider" "capacity_provider" {
  name = "${var.global.resource_prefix}-capacity-provider"

  auto_scaling_group_provider {
    auto_scaling_group_arn         = aws_autoscaling_group.ecs_asg.arn
    managed_termination_protection = "ENABLED"

    managed_scaling {
      maximum_scaling_step_size = 1000
      minimum_scaling_step_size = 1
      status                    = "ENABLED"
      target_capacity           = 80
    }
  }
}