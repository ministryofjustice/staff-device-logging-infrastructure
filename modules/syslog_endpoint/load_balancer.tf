resource "aws_lb" "load_balancer" {
  name               = "${var.short_prefix}-logging-syslog"
  load_balancer_type = "network"
  internal           = true

  subnet_mapping {
    subnet_id            = var.subnets[0]
    private_ipv4_address = var.load_balancer_private_ip_eu_west_2a
  }

  subnet_mapping {
    subnet_id            = var.subnets[1]
    private_ipv4_address = var.load_balancer_private_ip_eu_west_2b
  }

  subnet_mapping {
    subnet_id            = var.subnets[2]
    private_ipv4_address = var.load_balancer_private_ip_eu_west_2c
  }

  enable_deletion_protection = false

  tags = var.tags
}

resource "aws_lb_target_group" "target_group_udp" {
  name                 = "${var.short_prefix}-syslog-udp"
  protocol             = "UDP"
  vpc_id               = var.vpc_id
  port                 = "514"
  target_type          = "ip"
  deregistration_delay = 1500

  health_check {
    healthy_threshold   = 3
    unhealthy_threshold = 3
    port                = 80
    protocol            = "HTTP"
    path = "/"
  }
}

resource "aws_lb_listener" "udp" {
  load_balancer_arn = aws_lb.load_balancer.arn
  port              = "514"
  protocol          = "UDP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target_group_udp.arn
  }
}
