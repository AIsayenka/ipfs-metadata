resource "aws_ecr_repository" "service_ecr_repository" {
    name                 = "${var.service_name}-repository"
    image_tag_mutability = "MUTABLE"
    force_delete = true # for easy delete, not suitable for prod in any way
    image_scanning_configuration {
        scan_on_push = true
    }
}