data "aws_ssm_parameter" "ecs_ami" {
  name = "/aws/service/ecs/optimized-ami/amazon-linux-2/recommended/image_id"
}

resource "aws_autoscaling_group" "ecs_asg" {
    vpc_zone_identifier = module.vpc.private_subnets
    desired_capacity    = var.ec2_autoscaling_config.desired_capacity
    max_size            = var.ec2_autoscaling_config.max_size
    min_size            = var.ec2_autoscaling_config.min_size

    protect_from_scale_in = true

    launch_template {
        id      = aws_launch_template.ecs_lt.id
        version = "$Latest"
    }

    tag {
        key                 = "AmazonECSManaged"
        value               = true
        propagate_at_launch = true
    }

    tag {
        key                 = "Name"
        value               = "${var.global.resource_prefix}-ecs-asg"
        propagate_at_launch = true
    }

    lifecycle {
      ignore_changes = [
        "desired_capacity" # Ignore changes to desired capacity
        ]
    }
    
}

resource "aws_launch_template" "ecs_lt" {
    name_prefix   = "${var.global.resource_prefix}-ecs-lt"
    image_id      = data.aws_ssm_parameter.ecs_ami.value
    instance_type = "${var.ec2_config.instance_type}.${var.ec2_config.instance_size}"

    block_device_mappings {
        device_name = var.ec2_config.drive_config.volume_name
        ebs {
            volume_size = var.ec2_config.drive_config.volume_size
            volume_type = var.ec2_config.drive_config.volume_type
            delete_on_termination = var.ec2_config.drive_config.delete_on_termination
        }
    }
    vpc_security_group_ids = [aws_security_group.default.id]

    user_data     = base64encode(
        templatefile("${path.module}/_config/_templates/userdata.sh.tpl", {
            ECS_CLUSTER_NAME = aws_ecs_cluster.ecs_cluster.name
        })
    )
    iam_instance_profile { 
        arn = data.aws_iam_instance_profile.ecs_instance_role.arn
    }


    monitoring {
        enabled = true
    }

    tag_specifications {
        resource_type = "instance"
        tags = {
            Name = "${var.global.resource_prefix}-ecs-instance"
        }
    }
}