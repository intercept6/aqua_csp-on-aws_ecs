#################################################
# ALB
#################################################
resource "aws_security_group" "alb" {
  name        = "${var.project}-alb-sg"
  description = "${var.project}-alb-sg"
  vpc_id      = "${module.vpc.vpc_id}"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name      = "${var.project}-alb-sg"
    Terraform = "true"
  }
}

resource "aws_security_group_rule" "http-ingress-alb" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.alb.id}"
}

resource "aws_security_group_rule" "https-ingress-alb" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.alb.id}"
}

#################################################
# EC2
#################################################
resource "aws_security_group" "ec2" {
  name        = "${var.project}-ec2-sg"
  description = "${var.project}-ec2-sg"
  vpc_id      = "${module.vpc.vpc_id}"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name      = "${var.project}-ec2-sg"
    Terraform = "true"
  }
}

resource "aws_security_group_rule" "http_ingress-ec2" {
  type                     = "ingress"
  from_port                = "${var.aqua_server_port}"
  to_port                  = "${var.aqua_server_port}"
  protocol                 = "tcp"
  source_security_group_id = "${aws_security_group.alb.id}"
  security_group_id        = "${aws_security_group.ec2.id}"
}

#################################################
# rds
#################################################
resource "aws_security_group" "rds" {
  name        = "${var.project}-rds-sg"
  description = "${var.project}-rds-sg"
  vpc_id      = "${module.vpc.vpc_id}"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name      = "${var.project}-rds-sg"
    Terraform = "true"
  }
}

resource "aws_security_group_rule" "postgres_ingress-rds" {
  type                     = "ingress"
  from_port                = "${var.postgres_port}"
  to_port                  = "${var.postgres_port}"
  protocol                 = "tcp"
  source_security_group_id = "${aws_security_group.ec2.id}"
  security_group_id        = "${aws_security_group.rds.id}"
}
