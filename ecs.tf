resource "aws_ecs_cluster" "cluster" {
  name = "${var.project}-cluster"

  tags = {
    Name      = "${var.project}-cluster"
    Terraform = "true"
  }
}

resource "aws_ecs_service" "service" {
  name            = "${var.project}-service"
  cluster         = "${aws_ecs_cluster.cluster.id}"
  task_definition = "${aws_ecs_task_definition.task_definition.arn}"
  desired_count   = 1
  iam_role        = "${data.aws_iam_role.service_role-ecs-service.arn}"

  load_balancer {
    target_group_arn = "${aws_lb_target_group.lb.arn}"
    container_name   = "aqua-server"
    container_port   = "${var.aqua_server_port}"
  }
}

resource "aws_ecs_task_definition" "task_definition" {
  family                = "${var.project}-server"
  container_definitions = "${data.template_file.service.rendered }"
  execution_role_arn    = "${aws_iam_role.task_execution_role.arn}"
  network_mode          = "bridge"

  volume {
    name      = "docker-socket"
    host_path = "/var/run/docker.sock"
  }

  tags = {
    Name      = "${var.project}-service"
    Terraform = "true"
  }
}

data "template_file" "service" {
  template = "${file("task-definitions/service.tmpl.json")}"

  vars = {
    awslogs_group        = "/ecs/${var.project}"
    awslogs_region       = "${var.region}"
    aqua_server_port     = "${var.aqua_server_port}"
    admin_password       = "${var.secretsmanager_admin_password}"
    db_hostname          = "${module.db.this_db_instance_address}"
    db_port              = "${var.postgres_port}"
    db_username          = "${var.postgres_username}"
    db_password          = "${var.secretsmanager_db_password}"
    credentialsParameter = "${data.aws_secretsmanager_secret.container_repository.arn}"
  }
}
