resource "aws_lb" "service_lb" {
    name               = "${var.service_name}-lb"
    internal           = false
    load_balancer_type = "application"
    security_groups    = [var.security_groups.all_open]
    subnets            = var.subnets.public
    enable_deletion_protection = false
}

resource "aws_lb_target_group" "target_group_1" {
    name     = "${var.service_name}-tg-1"
    port     = var.task_definition_config.container_port
    target_type = "ip"
    protocol = "HTTP"
    vpc_id   = var.vpc_id
}

resource "aws_lb_target_group" "target_group_2" {
    name     = "${var.service_name}-tg-2"
    port     = var.task_definition_config.container_port
    target_type = "ip"
    protocol = "HTTP"
    vpc_id   = var.vpc_id
}

resource "aws_lb_listener" "http_listener" {
    load_balancer_arn = aws_lb.service_lb.arn
    port              = var.load_balancer_configuration.listener_port
    protocol          = "HTTP"

    default_action {
        type             = "forward"
        target_group_arn = length(aws_lb_target_group.target_group_1.arn) > 0 ? aws_lb_target_group.target_group_1.arn : aws_lb_target_group.target_group_2.arn
    }
}