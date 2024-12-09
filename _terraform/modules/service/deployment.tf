module "deployment" {
    source = "../../modules/deployment"
    service_name = var.service_name

    github_repo = var.github_repo
    github_branch = var.github_branch

    aws_region = var.aws_region
    vpc_id = var.vpc_id
    subnets = var.subnets

    ecr_repository_url = aws_ecr_repository.service_ecr_repository.repository_url
    ecr_repository_arn = aws_ecr_repository.service_ecr_repository.arn

    security_groups = var.security_groups

    code_build_config = var.code_build_config

    code_deploy_config = var.code_deploy_config

    ecs_config = merge(var.ecs_config, {
        service_name = module.ecs_service.name
    })

    load_balancer_config = {
      listener_arn = aws_lb_listener.http_listener.arn
      target_group_1_arn = aws_lb_target_group.target_group_1.arn
      target_group_2_arn = aws_lb_target_group.target_group_2.arn
    }

    codestar_arn = var.codestar_arn

    # stages = [
    #     {
    #         name = "Source"
    #         category = "Source"
    #         owner = "AWS"
    #         provider = "CodeStarSourceConnection"
    #         input_artifacts = []
    #         output_artifacts = ["SourceArtifact"]
    #         version = "1"
    #         configuration = {
    #             connectionArn = var.codestar_arn
    #             BranchName = var.github_branch
    #             RepositoryName = var.github_repo
    #         }
    #     },
    #     {
    #         name = "Build"
    #         category = "Build"
    #         owner = "AWS"
    #         provider = "CodeBuild"
    #         input_artifacts = ["SourceArtifact"]
    #         output_artifacts = ["BuildArtifact"]
    #         version = "1"
    #         configuration = {
    #             ProjectName = "${var.service_name}-${var.github_branch}-codebuild"
    #         }
    #     },
    #     {
    #         name = "Deploy"
    #         category = "Deploy"
    #         owner = "AWS"
    #         provider = "CodeDeploy"
    #         input_artifacts = ["BuildArtifact"]
    #         output_artifacts = []
    #         version = "1"
    #         configuration = {}
    #     }
    # ]


}