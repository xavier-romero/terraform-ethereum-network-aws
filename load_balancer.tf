resource "aws_lb" "public-alb" {
  name               = "${var.project}-${var.network}-public"
  internal           = false
  load_balancer_type = "application"
  idle_timeout       = 600

  subnets = module.vpc.public_subnets

  security_groups = [
    aws_security_group.public-alb_sg.id,
    aws_security_group.public-alb-targets_sg.id
  ]

  depends_on = [
    module.vpc.igw_id
  ]

  tags = local.tags
}

resource "aws_lb_listener" "https" {
  load_balancer_arn = aws_lb.public-alb.arn
  port              = 443
  protocol          = "HTTPS"
  certificate_arn   = aws_acm_certificate.wildcard_certificate.arn
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ethereum_network.arn
  }
  tags = local.tags
}
