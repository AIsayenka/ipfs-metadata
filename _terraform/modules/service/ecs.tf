module "ecs_service" {
  source = "terraform-aws-modules/ecs/aws//modules/service"

  depends_on = [ aws_ecr_repository.service_ecr_repository ]

  name  = "${var.service_name}-service"
  
  subnet_ids = var.subnets.private

  cluster_arn = var.ecs_config.cluster_arn

  # ... omitted for brevity
  launch_type = var.ecs_config.launch_type
  desired_count = var.ecs_config.desired_count
  
  load_balancer = [
    {
      target_group_arn = length(aws_lb_target_group.target_group_1.arn) > 0 ? aws_lb_target_group.target_group_1.arn : aws_lb_target_group.target_group_2.arn
      container_name = "${var.service_name}-service"
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

  enable_ecs_managed_tags = true

  container_definitions = {
    default = {
      name  = "${var.service_name}-service"
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