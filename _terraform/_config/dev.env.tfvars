global = {
    region = "us-east-1",
    profile = "alex-aws-personal",
    resource_prefix = "dev",
    vpc_cidr_block = "10.0.0.0/16",
}

github_repo = "AIsayenka/ipfs-metadata"
github_branch = "main"

ec2_config = {
    # ami = "ami-0c44c487d367c865d",
    ami = "ami-0ad089d873abe31c4",
    instance_type = "t3",
    instance_size = "medium",
    drive_config = {
        volume_size = 30,
        volume_type = "gp2",
        volume_name = "/dev/xvda",
        delete_on_termination = true,
    },
}

ec2_autoscaling_config = {
    min_size = 1,
    max_size = 5,
    desired_capacity = 1,
}

ecs_cluster_config = {
    cluster_name = "dev-cluster",
}

ecs_service_defaults = {
    desired_count = 1,
    min_count = 1,
    max_count = 12,
    launch_type = "EC2",
    task_definition_config = {
        essential = false,
        memory = 2048,
        cpu = 1024,
        container_port = 8080,
    }
}

load_balancer_configuration = {
    listener_port = 80,
}

rds_config = {
    instance_size = "medium",
    instance_type = "t3",
    engine_version = "14.9",
    engine = "aurora-postgresql",
    instance_count = 1,
}

code_build_config = {
    image = "aws/codebuild/standard:4.0",
    compute_type = "BUILD_GENERAL1_SMALL",
    type= "LINUX_CONTAINER",
    buildspec = "buildspec.yml",
}

code_deploy_config = {
    compute_platform = "ECS",
    deployment_config_name = "CodeDeployDefault.ECSAllAtOnce",
    deployment_wait_time_in_minutes = 5,
}
