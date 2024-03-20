# ---------------------------------------------
# AWS Code Build
# ---------------------------------------------
resource "aws_codebuild_project" "ecs_code_build" {
  name        = "${var.project}-${var.environment}-ecs-code-build"
  description = "${var.project}-${var.environment}-ecs-code-build"
  # ビルドがタイムアウトになるまでの時間（分）
  build_timeout = var.code_build_timeout
  # CodeBuildプロジェクトが使用するIAMロールのARN
  service_role = aws_iam_role.code_pipeline_role.arn

  # 出力されるアーティファクトのタイプ。このプロジェクトではアーティファクトを出力しないため、"NO_ARTIFACTS"に設定しています。
  artifacts {
    type = "NO_ARTIFACTS"
  }

  # ビルド環境の設定
  environment {
    # ビルドに使用するコンピュートタイプ
    compute_type = "BUILD_GENERAL1_SMALL"
    # 使用するDockerイメージ
    image = "aws/codebuild/standard:4.0"
    # コンテナタイプ。この場合はLinuxコンテナを使用します。
    type = "LINUX_CONTAINER"
    # プライベッジモードを有効にするかどうか。Dockerコンテナ内でDockerコマンドを実行する場合にtrueに設定します。
    privileged_mode = true
    # 環境変数の設定。ECSのリポジトリURIを環境変数として渡しています。
    environment_variable {
      name  = "REPOSITORY_URI"
      value = aws_ecr_repository.ecr_repository.repository_url
    }
  }

  # ソースコードの取得元
  source {
    # ソースのタイプ。この場合はAWS CodeCommitリポジトリです。
    type = "CODECOMMIT"
    # CodeCommitリポジトリのURL
    location = aws_codecommit_repository.code_commit_repo.clone_url_http
    # ビルドする際に使用するビルドスペックファイルのパス
    buildspec = var.code_build_spec_yml
  }

  # ビルドするソースコードのバージョン。ここでは環境変数からブランチ名を指定しています。
  source_version = var.code_commit_branch_name
}
