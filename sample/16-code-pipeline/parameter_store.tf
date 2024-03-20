# ---------------------------------------------
# Parameter Store - Code Pipeline
# ---------------------------------------------
resource "aws_ssm_parameter" "ecr_repository_uri" {
  name  = "/codebuild/sample-project-dev-nextjs-repo/uri"
  type  = "SecureString"
  value = var.ssm_parameter_ecr_repo_uri
}