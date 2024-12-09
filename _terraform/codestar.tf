resource "aws_codestarconnections_connection" "code_star_connection" {
  name          = "CodeStar-connection"
  provider_type = "GitHub"
}