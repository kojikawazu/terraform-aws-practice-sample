# ---------------------------------------------
# AWS Code Pipeline
# ---------------------------------------------
resource "aws_codepipeline" "ecs_code_pipeline" {
  name = "${var.project}-${var.environment}-ecs-code-pipeline"
  # CodePipelineが他のAWSサービスと連携する際に使用するIAMロールのARNを指定
  role_arn = aws_iam_role.code_pipeline_role.arn

  # ビルド成果物を格納するS3バケットの設定を行います。
  artifact_store {
    type     = "S3"
    location = aws_s3_bucket.s3_bucket_code_pipeline.bucket
  }

  # このステージでは、AWS CodeCommitからソースコードの変更を検出して取得します。
  stage {
    name = "Source"
    action {
      name             = "Source"
      category         = "Source"
      owner            = "AWS"
      provider         = "CodeCommit"
      version          = 1
      output_artifacts = ["source_output"]

      configuration = {
        RepositoryName = aws_codecommit_repository.code_commit_repo.repository_name
        BranchName     = var.code_commit_branch_name
      }
    }
  }

  # ソースステージで取得したコードをビルドします。ビルドはAWS CodeBuildを使用します。
  stage {
    name = "Build"
    action {
      name             = "Build"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      input_artifacts  = ["source_output"]
      output_artifacts = ["build_output"]
      version          = "1"
      configuration = {
        ProjectName = aws_codebuild_project.ecs_code_build.name
      }
    }
  }

  # ビルドステージの成果物をAWS ECSにデプロイします。
  stage {
    name = "Deploy"
    action {
      name            = "Deploy"
      category        = "Deploy"
      owner           = "AWS"
      provider        = "ECS"
      input_artifacts = ["build_output"]
      version         = "1"

      configuration = {
        ClusterName = aws_ecs_cluster.ecs_cluster.name
        ServiceName = aws_ecs_service.ecs_service.name
        FileName    = var.code_deploy_image_definitions
      }
    }
  }
}
