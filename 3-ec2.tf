data "aws_caller_identity" "account" {}

# CONTROL PLANE
resource "aws_instance" "control_plane" {
  ami                    = var.ami
  instance_type          = "t2.medium"
  subnet_id              = aws_subnet.public_subnet_1.id
  vpc_security_group_ids = [aws_security_group.controlplane_security_group.id]
  key_name = var.key_name

  root_block_device {
    volume_size = 30 # in GB
    volume_type = "gp3"
    encrypted   = true
  }

  user_data = templatefile("${path.module}/templates/control-plane.tftpl",
  { pod-network-cidr = var.pod-network-cidr, 
  account_id = data.aws_caller_identity.account.account_id,
  load_balancer_controller_iam_role = aws_iam_role.alb_ingress_controller.name
  },
  )

  # Restart instance to ensure user data is updated
  user_data_replace_on_change = true

  tags = {
    Name = "Control Plane"
  }
}

# ----------------------------------------------------------------------------

resource "aws_instance" "worker_node_1" {
  ami                    = var.ami
  instance_type          = "t2.medium"
  subnet_id              = aws_subnet.public_subnet_2.id
  vpc_security_group_ids = [aws_security_group.worker_security_group.id]
  key_name               = var.key_name
  iam_instance_profile   = aws_iam_instance_profile.node_workers.name

  root_block_device {
    volume_size = 30 # in GB
    volume_type = "gp3"
    encrypted   = true
  }

  user_data = templatefile("${path.module}/templates/worker-node.tftpl",
  {}
  )

  # Restart instance to ensure user data is updated
  user_data_replace_on_change = true

  tags = {
    Name = "Worker Node 1"
  }
}


resource "aws_instance" "worker_node_2" {
  ami                    = var.ami
  instance_type          = "t2.medium"
  subnet_id              = aws_subnet.public_subnet_3.id
  vpc_security_group_ids = [aws_security_group.worker_security_group.id]
  key_name               = var.key_name
  iam_instance_profile   = aws_iam_instance_profile.node_workers.name

  root_block_device {
    volume_size = 30 # in GB
    volume_type = "gp3"
    encrypted   = true
  }

  user_data = templatefile("${path.module}/templates/worker-node.tftpl",
  {}
  )

  # Restart instance to ensure user data is updated
  user_data_replace_on_change = true

  tags = {
    Name = "Worker Node 2"
  }
}
