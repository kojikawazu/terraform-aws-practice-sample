# ---------------------------------------------
# CloudWatch - ロググループ
# ---------------------------------------------
resource "aws_cloudwatch_log_group" "ecs_log_group" {
  name = "/ecs/nginx/cloudwatch"
}