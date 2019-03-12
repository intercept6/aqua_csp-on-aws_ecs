#################################################
# Target Group
#################################################
resource "aws_lb_target_group" "lb" {
  name     = "${var.project}-lb-tg"
  port     = "${var.aqua_server_port}"
  protocol = "HTTP"
  vpc_id   = "${module.vpc.vpc_id}"
}
