module "ecs_service" {
  source = "terraform-aws-modules/ecs/aws//modules/service"

  depends_on = [ aws_ecr_repository.service_ecr_repository ]

  name  = "${var.service_name}-ecs-service"
  
  subnet_ids = var.subnets.private
  security_group_ids = [var.security_groups.default]

  cluster_arn = var.ecs_config.cluster_arn

  # ... omitted for brevity
  launch_type = var.ecs_config.launch_type
  desired_count = var.ecs_config.desired_count
  
  load_balancer = [
    {
      target_group_arn = length(aws_lb_target_group.target_group_1.arn) > 0 ? aws_lb_target_group.target_group_1.arn : aws_lb_target_group.target_group_2.arn
      container_name = "${var.service_name}"
      container_port = var.task_definition_config.container_port
      # elb_name = aws_lb.service_lb.name
    }
  ]

  deployment_controller = {
      type ="CODE_DEPLOY"
    }

  requires_compatibilities = [
    var.ecs_config.launch_type
  ]

  enable_autoscaling = true
  autoscaling_max_capacity = var.ecs_config.max_count
  autoscaling_min_capacity = var.ecs_config.min_count
  autoscaling_policies = {
  "cpu": {
    "policy_type": "TargetTrackingScaling",
    "target_tracking_scaling_policy_configuration": {
      "predefined_metric_specification": {
        "predefined_metric_type": "ECSServiceAverageCPUUtilization"
      }
    }
  },
  "memory": {
    "policy_type": "TargetTrackingScaling",
    "target_tracking_scaling_policy_configuration": {
      "predefined_metric_specification": {
        "predefined_metric_type": "ECSServiceAverageMemoryUtilization"
      }
    }
  }
}

  enable_ecs_managed_tags = true

  cpu = var.task_definition_config.container_cpu
  memory = var.task_definition_config.container_memory

  container_definitions = {
    default = {
      name  = "${var.service_name}"
      image = "${aws_ecr_repository.service_ecr_repository.repository_url}:latest"
      cpu   = var.task_definition_config.container_cpu
      memory = var.task_definition_config.container_memory
      essential = true
      port_mappings = [
        {
          containerPort = var.task_definition_config.container_port
          protocol = "tcp"
        }
      ]
      enable_cloudwatch_logging = false
      secrets = [
         for secret in var.secret_env_vars: 
         {
            name = secret.name
            valueFrom = secret.value_from
          }
      ]
      enable_cloudwatch_logging = true
      readonly_root_filesystem = false
    }
  }

  capacity_provider_strategy = [
    {
      capacity_provider = var.ecs_config.capacity_provider_name
      weight = 100
      base = 0
    }
  ]

  ignore_task_definition_changes = true
}