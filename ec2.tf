resource "aws_key_pair" "network_key_pair" {
  key_name   = "network_${var.project}_${var.network}"
  public_key = var.network_key_pair
  tags       = local.tags
}

resource "aws_eip" "netowrk_eip" {
  count    = var.node_count
  instance = aws_instance.network[count.index].id
  vpc      = true
  tags     = merge(local.tags, tomap({ "Name" = "network-${var.project}-${var.network}-${count.index}" }))
}

resource "aws_network_interface" "network_net" {
  count = var.node_count
  # modulus 3 so nodes are split equally across subnets
  subnet_id = module.vpc.public_subnets[count.index % 3]
  security_groups = [
    aws_security_group.network_sg.id,
    aws_security_group.public-alb-targets_sg.id,
  ]
}

data "template_file" "network_sh" {
  count    = var.node_count
  template = file("files/network.sh.tpl")
  vars = {
    INDEX      = count.index
    NETWORK    = var.network
    RPC_PORT   = var.rpc_port
    NGINX_PORT = var.nginx_port
  }
}

resource "aws_instance" "network" {
  count         = var.node_count
  ami           = var.network_ami
  instance_type = var.network_size
  user_data     = data.template_file.network_sh[count.index].rendered

  key_name = aws_key_pair.network_key_pair.key_name

  root_block_device {
    volume_size = 32
    volume_type = "gp2"
  }

  network_interface {
    network_interface_id = aws_network_interface.network_net[count.index].id
    device_index         = 0
  }

  tags = merge(local.tags, tomap({ "Name" = "network-${var.project}-${var.network}-${count.index}" }))
}

resource "aws_lb_target_group_attachment" "network" {
  count            = var.node_count
  target_group_arn = aws_lb_target_group.ethereum_network.arn
  target_id        = aws_instance.network[count.index].id
  port             = var.nginx_port
}