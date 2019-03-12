#################################################
# ECS Instance Role
#################################################

resource "aws_iam_instance_profile" "instance_profile-ecs_instance" {
  name = "${var.project}-ecs-instance_profile"
  role = "${aws_iam_role.instance_role-ecs_instance.name}"
}

resource "aws_iam_role" "instance_role-ecs_instance" {
  name               = "${var.project}-ecs_instance-iam_role"
  assume_role_policy = "${data.aws_iam_policy_document.trust_policy-ecs_instance.json}"
}

data "aws_iam_policy_document" "trust_policy-ecs_instance" {
  statement {
    sid = "1"

    actions = [
      "sts:AssumeRole",
    ]

    principals = {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy_attachment" "policy_attachment-ssm-ecs_instance" {
  role       = "${aws_iam_role.instance_role-ecs_instance.name}"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2RoleforSSM"
}

resource "aws_iam_role_policy_attachment" "policy_attachment-ec2_container_service-ecs_instance" {
  role       = "${aws_iam_role.instance_role-ecs_instance.name}"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}

#################################################
# ECS Service Role
#################################################

data "aws_iam_role" "service_role-ecs-service" {
  name = "AWSServiceRoleForECS"
}

#################################################
# ECS Task Execution Role
#################################################
data "aws_kms_alias" "secretsmanager" {
  name = "alias/aws/secretsmanager"
}

data "aws_iam_policy_document" "permission_policy_task_execution_role" {
  statement {
    sid = "1"

    actions = [
      "kms:Decrypt",
    ]

    resources = [
      "${data.aws_kms_alias.secretsmanager.arn}",
    ]
  }

  statement {
    sid = "2"

    actions = [
      "secretsmanager:GetSecretValue",
    ]

    resources = [
      "${data.aws_secretsmanager_secret_version.container_repository.arn}",
      "${data.aws_secretsmanager_secret_version.admin_password.arn}",
      "${data.aws_secretsmanager_secret_version.db_password.arn}",
    ]
  }

  statement {
    sid = "3"

    actions = [
      "ssm:GetParameters",
    ]

    resources = ["*"]
  }
}

data "aws_iam_policy_document" "task_execution_role_trust" {
  statement {
    sid = "1"

    actions = [
      "sts:AssumeRole",
    ]

    principals = {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "task_execution_role" {
  name               = "${var.project}-task_execution_role"
  assume_role_policy = "${data.aws_iam_policy_document.task_execution_role_trust.json}"
}

resource "aws_iam_policy" "task_execution_role" {
  name   = "task_execution_role"
  path   = "/"
  policy = "${data.aws_iam_policy_document.permission_policy_task_execution_role.json}"
}

resource "aws_iam_role_policy_attachment" "policy_attachment-secretsmanager-task_execution_role" {
  role       = "${aws_iam_role.task_execution_role.name}"
  policy_arn = "${aws_iam_policy.task_execution_role.arn}"
}

resource "aws_iam_role_policy_attachment" "policy_attachment-amazon_ecs_task_execution_role_policy-task_execution_role" {
  role       = "${aws_iam_role.task_execution_role.name}"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}
