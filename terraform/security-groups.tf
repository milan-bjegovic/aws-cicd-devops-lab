resource "aws_security_group" "app" {
  name        = "launch-wizard-1"
  description = "launch-wizard-1 created 2026-09-04T13:00:32.170Z"
  vpc_id      = "vpc-07da35f64503504ce"

  ingress {
    description = null
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = null
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["87.116.132.109/32"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}