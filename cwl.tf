resource "aws_cloudwatch_log_group" "ecs" {
  name = "/ecs/${var.project}"
}
