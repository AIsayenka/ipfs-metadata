resource "aws_ssm_parameter" "db_host" {
    name        = "DB_HOST"
    description = "The database name"
    type        = "String"
    value       = aws_rds_cluster.aurora_cluster.endpoint
    overwrite = true
}
resource "aws_ssm_parameter" "db_name" {
    name        = "DB_NAME"
    description = "The database name"
    type        = "String"
    value       = var.db_name
    overwrite = true
}

resource "aws_ssm_parameter" "db_username" {
    name        = "DB_USERNAME"
    description = "The database username"
    type        = "String"
    value       = var.db_username
    overwrite = true
}

resource "aws_ssm_parameter" "db_password" {
    name        = "DB_PASSWORD"
    description = "The database password"
    type        = "SecureString"
    value       = var.db_password
    overwrite = true
}

resource "aws_ssm_parameter" "db_port" {
    name        = "DB_PORT"
    description = "The database port"
    type        = "String"
    value       = var.db_port
    overwrite = true
}