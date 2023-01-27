resource "aws_security_group" "public-alb_sg" {
  vpc_id      = module.vpc.vpc_id
  name        = "PUBLIC ALB SG"
  description = "security group for public ALB"

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = local.tags
}

resource "aws_security_group" "public-alb-targets_sg" {
  vpc_id      = module.vpc.vpc_id
  name        = "ACCESS ALB TO TARGETS SG"
  description = "security group allowing ALB access targets"

  ingress {
    from_port = 0
    to_port   = 0
    protocol  = -1
    self      = true
  }
  tags = local.tags
}

resource "aws_security_group" "network_sg" {
  vpc_id      = module.vpc.vpc_id
  name        = "NETWORK NODE SG"
  description = "security group for network nodes"

  ingress {
    from_port   = 8545
    to_port     = 8545
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = local.tags
}