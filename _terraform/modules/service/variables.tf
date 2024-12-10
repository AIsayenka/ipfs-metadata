variable "service_name" {
    description = "Service name"
    type = string
}

variable "github_repo" {
    description = "GitHub repository"
    type = string
}

variable "github_branch" {
    description = "GitHub branch"
    type = string
}

variable "aws_region" {
    description = "AWS region"
    type = string
}

variable "vpc_id" {
    description = "VPC ID"
    type = string
}

variable "task_definition_config" {
    description = "Task definition"
    type = object({
        container_port = number
        container_memory = number
        container_cpu = number
        essential = bool
    })
}

variable "ecs_config" {
    description = "ECS Service defaults"
    type = object({
        cluster_name = string
        cluster_arn = string
        desired_count = number
        min_count = number
        max_count = number
        launch_type = string
        capacity_provider_arn = string
        capacity_provider_name = string
    })
}


variable "load_balancer_configuration"{
    description = "Load balancer configuration"
    type = object({
        listener_port = number
    })
}

variable "subnets" {
    description = "Subnets"
    type = object(
        {
            public = list(string)
            private = list(string)
        }
    )
}

variable "codestar_arn" {
    description = "CodeStart ARN"
    type = string
}

variable "default_security_group_id" {
    description = "Default security group ID"
    type = string
}

variable "code_build_config" {
    description = "CodeBuild configuration"
    type = object({
        image = string
        compute_type = string
        type = string
        buildspec = string
    })
}

variable "code_deploy_config" {
    description = "CodeDeploy configuration"
    type = object({
        compute_platform = string
        deployment_config_name = string
        deployment_wait_time_in_minutes = number
    })
}

variable "env_vars" {
    description = "Environment variables"
    type = list(object({
        name = string
        value = string
    }))
    default = []
}

variable "security_groups" {
    description = "Security groups"
    type = object({
      default = string
      all_open = string
    })
}

variable "secret_env_vars" {
    description = "Secret environment variables"
    type = list(object({
        name = string
        value_from = string
    }))
}

variable "aws_account_id" {
    description = "AWS account ID"
    type = string
}