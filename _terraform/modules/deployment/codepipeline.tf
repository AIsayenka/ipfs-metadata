# CodePipeline
# locals {
#   processed_stages = [
#     for stage in var.stages : {
#       name             = stage.name
#       category         = stage.category
#       owner            = stage.owner
#       provider         = stage.provider != "" ? stage.provider : "AWS"
#       version          = stage.version != "" ? stage.version : "1"
#       input_artifacts  = stage.input_artifacts != null ? stage.input_artifacts : []
#       output_artifacts = stage.output_artifacts != null ? stage.output_artifacts : []
#       configuration    = merge(
#         stage.configuration,
#         stage.category == "Build" ? {
#           ProjectName = aws_codebuild_project.ecs_service_codebuild.id
#         } :
#         stage.category == "Deploy" ? {
#           ApplicationName     = aws_codedeploy_app.ecs_service_codedeploy_app.name,
#           DeploymentGroupName = aws_codedeploy_deployment_group.ecs_service_deployment_group.id
#         } : {}
#       )
#     }
#   ]
# }

resource "aws_codepipeline" "ecs_pipeline" {
    name     = "${var.service_name}-codepipeline"
    role_arn = aws_iam_role.codepipeline_role.arn
    artifact_store {
        type     = "S3"
        location = aws_s3_bucket.artifact_bucket.bucket
    }

    # it was supposed to be dynamic, but oh well
    stage {
      name = "Source"
      action {
          name = "Source"
          category = "Source"
          owner = "AWS"
          provider = "CodeStarSourceConnection"
          input_artifacts = []
          output_artifacts = ["SourceArtifact"]
          version = "1"
          configuration = {
              ConnectionArn     = var.codestar_arn
              BranchName = var.github_branch
              FullRepositoryId = var.github_repo
          }
      }
    }
    stage {
      name = "Build"
      action {
            name = "Build"
            category = "Build"
            owner = "AWS"
            provider = "CodeBuild"
            input_artifacts = ["SourceArtifact"]
            output_artifacts = ["BuildArtifact"]
            version = "1"
            configuration = {
                ProjectName = aws_codebuild_project.ecs_service_codebuild.id
            }
        }
      }
    stage {
      name = "Deploy"
      action {
          name = "Deploy"
          category = "Deploy"
          owner = "AWS"
          provider = "CodeDeploy"
          input_artifacts = ["BuildArtifact"]
          output_artifacts = []
          version = "1"
          configuration = {
             ApplicationName     = aws_codedeploy_app.ecs_service_codedeploy_app.name,
             DeploymentGroupName = aws_codedeploy_deployment_group.ecs_service_deployment_group.id
          }
      }
    }
}