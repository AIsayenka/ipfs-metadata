resource "aws_codedeploy_app" "ecs_service_codedeploy_app" {
  name = "${var.service_name}-codedeploy-app"

  compute_platform = var.code_deploy_config.compute_platform
}

resource "aws_codedeploy_deployment_group" "ecs_service_deployment_group" {
  app_name              = aws_codedeploy_app.ecs_service_codedeploy_app.name
  deployment_group_name = "${var.service_name}-deployment-group"
  service_role_arn      = aws_iam_role.codedeploy_role.arn

  deployment_style {
    deployment_option = "WITH_TRAFFIC_CONTROL"
    deployment_type   = "BLUE_GREEN"
  }

   blue_green_deployment_config {
        deployment_ready_option {
            action_on_timeout    = "STOP_DEPLOYMENT"
            wait_time_in_minutes = var.code_deploy_config.deployment_wait_time_in_minutes
        }

        terminate_blue_instances_on_deployment_success {
            action = "TERMINATE"
            termination_wait_time_in_minutes = var.code_deploy_config.deployment_wait_time_in_minutes 
        }
    }

  load_balancer_info {
    target_group_pair_info {
      prod_traffic_route {
        listener_arns = [var.load_balancer_config.listener_arn]
      }
      target_group {
        name = var.load_balancer_config.target_group_1_name
      }
      target_group {
        name = var.load_balancer_config.target_group_2_name
      }
    }
  }

  deployment_config_name = var.code_deploy_config.deployment_config_name

  ecs_service {
    cluster_name = var.ecs_config.cluster_name
    service_name = var.ecs_config.service_name
  }
}