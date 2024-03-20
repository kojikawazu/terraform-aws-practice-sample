# ---------------------------------------------
# IAM - AWS Code Pipeline
# ---------------------------------------------
# このロールは、CodePipelineが他のAWSサービス（ECR、ECS、S3など）と連携する際に使用します。
resource "aws_iam_role" "code_pipeline_role" {
  name = "${var.project}-${var.environment}-ecs-codebuild-role"

  # このポリシーにより、CodePipelineサービスがこのロールを引き受ける（AssumeRole）ことが許可されます。
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = [
            "codebuild.amazonaws.com",
            "codepipeline.amazonaws.com",
            "ecs-tasks.amazonaws.com",
            "ecs.amazonaws.com"
          ],
        }
      },
    ]
  })
}

# ---------------------------------------------
# IAM Policy - AWS Code Pipeline
# ---------------------------------------------
# AWS CodePipelineが使用するIAMポリシーを定義し、上記で作成したIAMロールにアタッチします。
resource "aws_iam_role_policy" "code_pipeline_policy" {
  name = "${var.project}-${var.environment}-ecs-codebuild-policy"
  role = aws_iam_role.code_pipeline_role.id
  # ポリシードキュメントは下部で定義されています。
  policy = data.aws_iam_policy_document.code_pipeline_policy.json
}

# ---------------------------------------------
# IAM Policy Document - AWS Code Pipeline
# ---------------------------------------------
# CodePipelineがECR、ECS、S3と連携するために必要なアクションを許可します。
data "aws_iam_policy_document" "code_pipeline_policy" {
  # ECRに関するアクションを許可します。
  statement {
    effect = "Allow"
    actions = [
      "ecr:GetAuthorizationToken",
      "ecr:BatchCheckLayerAvailability",
      "ecr:InitiateLayerUpload",
      "ecr:UploadLayerPart",
      "ecr:CompleteLayerUpload",
      "ecr:PutImage",
    ]
    resources = ["*"]
  }

  # ECSに関するアクションを許可します。
  statement {
    effect = "Allow"
    actions = [
      "ecs:RegisterTaskDefinition",
      "ecs:DeregisterTaskDefinition",
      "ecs:DescribeClusters",
      "ecs:DescribeTaskDefinition",
      "ecs:DescribeTasks",
      "ecs:ListTasks",
      "ecs:UpdateService",
      "ecs:CreateService",
      "ecs:DeleteService",
      "ecs:DescribeServices",
      "ecs:StartTask",
      "ecs:RunTask",
      "ecs:StopTask",
    ]
    resources = [
      aws_ecs_service.ecs_service.id,
      "*",
    ]
  }

  # S3に関するアクションを許可します。
  statement {
    effect = "Allow"
    actions = [
      "s3:GetObject",
      "s3:GetObjectVersion",
      "s3:GetBucketVersioning",
      "s3:PutObject",
      "s3:AbortMultipartUpload",
      "s3:ListBucketMultipartUploads",
      "s3:GetBucketLocation",
      "s3:GetBucketAcl",
      "s3:GetObjectAcl",
      "s3:PutObjectAcl",
    ]
    resources = [
      "${aws_s3_bucket.s3_bucket_code_pipeline.arn}/*",
    ]
  }

  # CloudWatch Logsへのアクセス権限を追加
  statement {
    effect = "Allow"
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      "logs:DescribeLogStreams",
    ]
    resources = [
      "${var.code_build_ecs_log_arn}:*",
    ]
  }

  # Systems Manager Parameter Store へのアクセス権限を追加
  statement {
    effect = "Allow"
    actions = [
      "ssm:GetParameter",
    ]
    resources = [
      aws_ssm_parameter.ecr_repository_uri.arn,
    ]
  }

  # iam:PassRoleの権限を追加
  statement {
    effect = "Allow"
    actions = [
      "iam:PassRole"
    ]
    resources = [
      aws_iam_role.ecs_task_execution_role.arn,
    ]
  }

  # CodeCommitへのアクセス権限を追加
  statement {
    effect = "Allow"
    actions = [
      "codecommit:GetBranch",
      "codecommit:GetCommit",
      "codecommit:GetRepository",
      "codecommit:ListBranches",
      "codecommit:GitPull",
      "codecommit:UploadArchive",
      "codecommit:GetUploadArchiveStatus",
    ]
    resources = [
      aws_codecommit_repository.code_commit_repo.arn,
    ]
  }

  # CodeBuildプロジェクトへのアクセス権限を追加
  statement {
    effect = "Allow"
    actions = [
      "codebuild:StartBuild",
      "codebuild:BatchGetBuilds",
    ]
    resources = [
      aws_codebuild_project.ecs_code_build.arn,
    ]
  }

  statement {
    effect = "Allow"
    actions = [
      "codedeploy:CreateDeployment",
      "codedeploy:GetApplicationRevision",
      "codedeploy:GetApplication",
      "codedeploy:GetDeployment",
      "codedeploy:GetDeploymentConfig",
      "codedeploy:RegisterApplicationRevision",
    ]
    resources = ["*"]
  }
}
