module ecs_service {
    source = "./modules/service"
    depends_on = [
        aws_ssm_parameter.db_host,
        aws_ssm_parameter.db_name,
        aws_ssm_parameter.db_username,
        aws_ssm_parameter.db_password,
        aws_ssm_parameter.db_port
    ]
    service_name = "ipfs-metadata"
    github_repo = var.github_repo
    github_branch = var.github_branch
    aws_region = var.global.region
    vpc_id = module.vpc.vpc_id
    task_definition_config = {
        container_port = var.ecs_service_defaults.task_definition_config.container_port
        container_memory = var.ecs_service_defaults.task_definition_config.memory
        container_cpu = var.ecs_service_defaults.task_definition_config.cpu
        essential = var.ecs_service_defaults.task_definition_config.essential
    }
    load_balancer_configuration = {
        listener_port = var.load_balancer_configuration.listener_port
    }
    subnets = {
        public = module.vpc.public_subnets
        private = module.vpc.private_subnets
    }
    codestar_arn = aws_codestarconnections_connection.code_star_connection.arn
    default_security_group_id = aws_security_group.default.id
    code_build_config = {
        image = var.code_build_config.image
        compute_type = var.code_build_config.compute_type
        type = var.code_build_config.type
        buildspec = var.code_build_config.buildspec
    }
    secret_env_vars = [
        {
            name = "POSTGRES_HOST"
            value_from = aws_ssm_parameter.db_host.arn
        },
        {
            name = "POSTGRES_USER"
            value_from = aws_ssm_parameter.db_username.arn
        },
        {
            name = "POSTGRES_PASSWORD"
            value_from = aws_ssm_parameter.db_password.arn
        },
        {
            name = "POSTGRES_DB"
            value_from = aws_ssm_parameter.db_name.arn
        },
        {
            name = "POSTGRES_PORT"
            value_from = aws_ssm_parameter.db_port.arn
        }
        
    ]

    ecs_config = {
        cluster_name = aws_ecs_cluster.ecs_cluster.name
        cluster_arn = aws_ecs_cluster.ecs_cluster.arn
        launch_type = var.ecs_service_defaults.launch_type
        desired_count = var.ecs_service_defaults.desired_count
        capacity_provider_arn = aws_ecs_capacity_provider.capacity_provider.arn
        capacity_provider_name = aws_ecs_capacity_provider.capacity_provider.name
    }

    security_groups = {
      default = aws_security_group.default.id
      all_open = aws_security_group.all_open.id
    }
    code_deploy_config = {
        compute_platform = var.code_deploy_config.compute_platform
        deployment_config_name = var.code_deploy_config.deployment_config_name
        deployment_wait_time_in_minutes = var.code_deploy_config.deployment_wait_time_in_minutes
    }


}