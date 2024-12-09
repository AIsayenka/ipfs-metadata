data "aws_iam_policy_document" "ecs_node_doc" {
  statement {
    actions = ["sts:AssumeRole"]
    effect  = "Allow"

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}
data "aws_iam_role" "ecs_instance_role" {
  name = "ecsInstanceRole"
}

data "aws_iam_instance_profile" "ecs_instance_role" {
  name = "ecsInstanceRole"
}

resource "aws_iam_role" "ecs_node_role" {
  name_prefix        = "${var.global.resource_prefix}-ecs-node-role"
  assume_role_policy = data.aws_iam_policy_document.ecs_node_doc.json
}

resource "aws_iam_role_policy_attachment" "ecs_node_role_policy" {
  role       = aws_iam_role.ecs_node_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}

# resource "aws_iam_role_policy_attachment" "ecs_node_role_container_registry_policy" {
#   role       = aws_iam_role.ecs_node_role.name
#   policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerRegistryReadOnly"
# }

resource "aws_iam_instance_profile" "ecs_node" {
  name_prefix = "${var.global.resource_prefix}-ecs-node-profile"
  path        = "/ecs/instance/"
  role        = aws_iam_role.ecs_node_role.name
}