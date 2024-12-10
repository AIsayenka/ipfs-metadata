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

variable "subnets" {
    description = "Subnets"
    type = object(
        {
            public = list(string)
            private = list(string)
        }
    )
}

variable "security_groups" {
    description = "Security groups"
    type = object(
        {
            all_open = string
            default = string
        }
    )
}

variable "code_build_config" {
    description = "CodeBuild configuration"
    type = object(
        {
            image = string
            compute_type = string
            type= string
            buildspec = string
        }
    )
}

variable "code_deploy_config" {
    description = "CodeDeploy configuration"
    type = object(
        {
            compute_platform = string
            deployment_config_name = string
            deployment_wait_time_in_minutes = number
        }
    )
}

variable "ecr_repository_url" {
    description = "ECR repository URL"
    type = string
}

variable "ecr_repository_arn" {
    description = "ECR repository arn"
    type = string
}

variable "codestar_arn" {
    description = "CodeStar connection ARN"
    type = string
}
variable "ecs_config" {
    description = "ECS configuration"
    type = object(
        {
            cluster_name = string
            cluster_arn = string
            service_name = string
            launch_type = string
            desired_count = number
            capacity_provider_arn = string
            capacity_provider_name = string
        }
    )
  
}

variable "load_balancer_config" {
    description = "Load balancer configuration"
    type = object(
        {
            listener_arn = string
            target_group_1_arn = string
            target_group_1_name = string
            target_group_2_arn = string
            target_group_2_name = string
        }
    )
  
}

variable "codebuild_env_vars" {
    description = "CodeBuild environment variables"
    type = list(object({
      name = string
      value = string
    }))
}