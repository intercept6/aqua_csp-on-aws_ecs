variable "region" {
  default = "ap-northeast-1"
}

variable "project" {
  default = "aqua"
}

variable "secretsmanager_container_repository" {
  default = "aqua/container_repository"
}

variable "secretsmanager_admin_password" {
  default = "aqua/admin_password"
}

variable "secretsmanager_db_password" {
  default = "aqua/db_password"
}

variable "ssh-key_name" {}

variable "ssl_certificate_id" {}

variable "instance_type" {
  default = "m5.large"
}

variable "db_instance_type" {
  default = "db.t2.large"
}

variable "postgres_username" {
  default = "postgres"
}

variable "postgres_port" {
  default = "5432"
}

variable "aqua_server_port" {
  default = "8080"
}

variable "lb_port" {
  default = "80"
}
