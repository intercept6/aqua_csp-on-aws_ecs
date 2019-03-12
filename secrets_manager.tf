data "aws_secretsmanager_secret" "container_repository" {
  name = "${var.secretsmanager_container_repository}"
}

data "aws_secretsmanager_secret" "admin_password" {
  name = "${var.secretsmanager_admin_password}"
}

data "aws_secretsmanager_secret" "db_password" {
  name = "${var.secretsmanager_db_password}"
}

data "aws_secretsmanager_secret_version" "container_repository" {
  secret_id = "${data.aws_secretsmanager_secret.container_repository.id}"
}

data "aws_secretsmanager_secret_version" "admin_password" {
  secret_id = "${data.aws_secretsmanager_secret.admin_password.id}"
}

data "aws_secretsmanager_secret_version" "db_password" {
  secret_id = "${data.aws_secretsmanager_secret.db_password.id}"
}
