# ---------------------------------------------
# S3 Bucket - AWS Code Pipeline
# ---------------------------------------------
# AWS CodePipelineがアーティファクトを保存するためのS3バケットを作成します。
resource "aws_s3_bucket" "s3_bucket_code_pipeline" {
  bucket = "${var.project}-${var.environment}-code-pipeline-bucket-2727"
}

# ---------------------------------------------
# S3 Bucket versioning - AWS Code Pipeline
# ---------------------------------------------
# S3バケットのバージョニングを有効化します。
# S3バケットでバージョニングを有効にすることで、バケット内のオブジェクトの複数のバージョンを保持できるようになります。
# これにより、誤って削除や上書きされたデータの回復が可能になります。
resource "aws_s3_bucket_versioning" "s3_bucket_versioning_code_pipeline" {
  # バージョニングを有効化するバケットの指定。
  bucket = aws_s3_bucket.s3_bucket_code_pipeline.id
  versioning_configuration {
    status = "Enabled"
  }
}

# ---------------------------------------------
# S3 Bucket lifecycle - AWS Code Pipeline
# ---------------------------------------------
# S3バケットのライフサイクルポリシーを設定します。
resource "aws_s3_bucket_lifecycle_configuration" "s3_bucket_lifecycle_conf_code_pipeline" {
  bucket = aws_s3_bucket.s3_bucket_code_pipeline.id

  rule {
    id = "rule-1"

    # オブジェクトが30日後に自動的に削除されるように設定します。
    # 不要なデータがバケット内に蓄積されるのを防ぎ、ストレージコストを節約できます。
    expiration {
      days = var.code_pipeline_s3_bucket_lifecycle_expiration
    }

    status = "Enabled"
  }
}

# ---------------------------------------------
# S3 Bucket policy - AWS Code Pipeline
# ---------------------------------------------
# S3バケットポリシーを設定します。
resource "aws_s3_bucket_policy" "s3_bucket_policy_code_pipeline" {
  bucket = aws_s3_bucket.s3_bucket_code_pipeline.id

  # ポリシーの内容をJSON形式で記述します。
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect    = "Allow",
        Principal = "*",
        Action = [
          "s3:GetObject",
        ],
        Resource = "${aws_s3_bucket.s3_bucket_code_pipeline.arn}/*",
      },
    ],
  })
}
