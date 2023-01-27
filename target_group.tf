resource "aws_lb_target_group" "ethereum_network" {
  name                 = "${var.project}-${var.network}-ethereum-network"
  port                 = var.rpc_port
  protocol             = "HTTP"
  protocol_version     = "HTTP1"
  slow_start           = 0
  target_type          = "instance"
  vpc_id               = module.vpc.vpc_id
  deregistration_delay = 30

  health_check {
    path                = "/health"
    enabled             = true
    healthy_threshold   = 2
    interval            = 30
    unhealthy_threshold = 7
    timeout             = 10
    matcher             = "200"
  }

  depends_on = [aws_lb.public-alb]

  tags = local.tags
}