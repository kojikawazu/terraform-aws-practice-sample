# ---------------------------------------------
# AWS Code Commit
# ---------------------------------------------
resource "aws_codecommit_repository" "code_commit_repo" {
  repository_name = "${var.project}-${var.environment}-code-commit-repo"
  description     = "CodeCommit repository for ${var.project} in ${var.environment}"
}