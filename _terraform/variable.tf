variable "global" {
    description = "Global variables"
    type = object({
        region  = string
        profile = string
        resource_prefix = string
        vpc_cidr_block = string
    })
}

variable "github_repo" {
    description = "GitHub repository"
    type = string
}

variable "github_branch" {
    description = "GitHub branch"
    type = string
}

variable "ec2_config" {
    description = "EC2 configuration"
    type = object({
        ami           = string
        instance_type = string
        instance_size = string
        drive_config  = object({
            volume_size            = number
            volume_type            = string
            volume_name            = string
            delete_on_termination  = bool
        })
    })
}

variable "ec2_autoscaling_config" {
    description = "EC2 Autoscaling configuration"
    type = object({
        min_size         = number
        max_size         = number
        desired_capacity = number
    })
}

variable "ecs_cluster_config" {
    description = "ECS Cluster configuration"
    type = object({
        cluster_name = string
    })
}

variable "ecs_service_defaults" {
    description = "ECS Service defaults"
    type = object({
        desired_count = number
        launch_type   = string
        task_definition_config = object({
            essential = bool
            memory    = number
            cpu       = number
            container_port = number
        })
    })
}

variable "load_balancer_configuration" {
    description = "Load balancer configuration"
    type = object({
        listener_port = number
    })
  
}

variable "rds_config" {
    description = "RDS configuration"
    type = object({
        instance_size = string
        instance_type = string
        engine_version = string
        engine = string
        instance_count = number
    })
}

variable "code_build_config" {
    description = "CodeBuild configuration"
    type = object({
        image        = string
        compute_type = string
        type         = string
        buildspec    = string
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

variable "db_name" {
    description = "Database name"
    type = string
}

variable "db_username" {
    description = "Database username"
    type = string
}

variable "db_password" {
    description = "Database password"
    type = string
    sensitive = true
}

variable "db_port" {
    description = "Database port"
    type = number
}