resource "aws_security_group" "default" {
  vpc_id = module.vpc.vpc_id
  name = "${var.global.resource_prefix}-default-sg"
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.global.vpc_cidr_block]
  }
}

resource "aws_security_group" "all_open" {
  vpc_id = module.vpc.vpc_id
  name = "${var.global.resource_prefix}-all-open-sg"
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}