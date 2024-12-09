resource "aws_codebuild_project" "ecs_service_codebuild" {
  name          = "${var.service_name}-${var.github_branch}-codebuild"
  service_role  = aws_iam_role.codebuild_role.arn
  artifacts {
    type = "CODEPIPELINE"
  }
  environment {
    compute_type                = var.code_build_config.compute_type
    image                       = var.code_build_config.image
    type                        = var.code_build_config.type
    privileged_mode             = true # need it for docker 
    image_pull_credentials_type = "CODEBUILD"
    environment_variable {
      name = "REPOSITORY_URI"
      value = var.ecr_repository_url
    }
    environment_variable {
      name = "AWS_DEFAULT_REGION"
      value = var.aws_region
    }
    environment_variable {
      name = "CONTAINER_NAME"
      value = var.service_name
    }
  }
  source {
    type            = "CODEPIPELINE"
    buildspec       = var.code_build_config.buildspec
  }
}