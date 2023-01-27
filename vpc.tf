# resource "aws_vpc" "ethereum" {
#   cidr_block       = var.cidr
#   instance_tenancy = "default"

#   tags = local.tags
# }

# resource "aws_subnet" "public" {
#   count            = 3
#   vpc_id           = aws_vpc.ethereum.id
#   cidr_block       = cidrsubnet(var.cidr, 8, count.index)
#   availabiliy_zone = local.regions[count.index]

#   tags = local.tags
# }


module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 3.14.0"

  name = "network-${var.project}-${var.network}"
  cidr = var.cidr

  azs             = ["${local.region}a", "${local.region}b", "${local.region}c"]
  public_subnets  = [cidrsubnet(var.cidr, 8, 0), cidrsubnet(var.cidr, 8, 1), cidrsubnet(var.cidr, 8, 2)]
  private_subnets = [cidrsubnet(var.cidr, 8, 3), cidrsubnet(var.cidr, 8, 4), cidrsubnet(var.cidr, 8, 5)]
  # intra_subnets   = [cidrsubnet(var.cidr, 8, 6), cidrsubnet(var.cidr, 8, 7), cidrsubnet(var.cidr, 8, 8)]

  single_nat_gateway = true
  enable_nat_gateway = true

  tags = local.tags
}
