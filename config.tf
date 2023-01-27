provider "aws" {
  # profile is ignored, it always take the default one
  shared_config_files      = ["~/.aws/hermez_testnet_2_config"]
  shared_credentials_files = ["~/.aws/hermez_testnet_2_credentials"]
  region                   = "eu-west-1"
}

terraform {
  required_version = ">= 1.0"

  backend "local" {
    path = ".backend/terraform.tfstate"
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.17.0"
    }
  }
}

variable "project" {}
variable "network" {}
variable "cidr" {}
variable "rpc_port" { default = 8545 }
variable "nginx_port" { default = 80 }
variable "network_key_pair" {}
variable "network_ami" {}
variable "network_size" {}
variable "node_count" { default = 1 }
variable "existing_public_domain" {}

data "aws_region" "current" {}

locals {
  region = data.aws_region.current.name
  tags = {
    "Project" = var.project
    "Network" = var.network
  }
}
