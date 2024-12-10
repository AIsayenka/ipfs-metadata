resource "aws_s3_bucket" "artifact_bucket" {
    force_destroy = true # for easy delete
}