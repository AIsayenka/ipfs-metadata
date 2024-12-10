resource "aws_s3_bucket" "artifact_bucket" {
    bucket = "${var.service_name}-${var.aws_region}-${var.aws_account_id}-artifact-bucket"
    force_destroy = true # for easy delete
}