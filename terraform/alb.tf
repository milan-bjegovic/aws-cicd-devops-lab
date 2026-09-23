resource "aws_security_group" "alb" {
  name        = "devops-lab-alb-sg"
  description = "Security group for the DevOps Lab Application Load Balancer"
  vpc_id      = "vpc-07da35f64503504ce"

  ingress {
    description = "Allow HTTP from the Internet"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name      = "devops-lab-alb-sg"
    ManagedBy = "Terraform"
  }
}

resource "aws_lb" "app" {
  name               = "devops-lab-alb"
  internal           = false
  load_balancer_type = "application"

  security_groups = [
    aws_security_group.alb.id
  ]

  subnets = [
    "subnet-04257d4b254a2cad8",
    "subnet-04850d54d813e20cf",
    "subnet-0d280ff2d4cbbce9e"
  ]

  tags = {
    Name      = "devops-lab-alb"
    ManagedBy = "Terraform"
  }
}

resource "aws_lb_target_group" "app" {
  name     = "devops-lab-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = "vpc-07da35f64503504ce"

  health_check {
    enabled             = true
    path                = "/"
    protocol            = "HTTP"
    port                = "traffic-port"
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 5
    interval            = 30
    matcher             = "200-399"
  }

  tags = {
    Name      = "devops-lab-tg"
    ManagedBy = "Terraform"
  }
}


resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.app.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app.arn
  }
}