# Create a Public virtial machines (instances)

resource "aws_instance" "control_plane" {
  ami                    = "ami-04b70fa74e45c3917" # AMI in London region
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
  { pod-network-cidr = var.pod-network-cidr }
  )

  # Restart instance to ensure user data is updated
  user_data_replace_on_change = true

  tags = {
    Name = "Control Plane"
  }
}

# ----------------------------------------------------------------------------

resource "aws_instance" "worker_node_1" {
  ami                    = "ami-04b70fa74e45c3917" # AMI in London region
  instance_type          = "t2.medium"
  subnet_id              = aws_subnet.public_subnet_1.id
  vpc_security_group_ids = [aws_security_group.worker_security_group.id]
  key_name = var.key_name

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
  ami                    = "ami-04b70fa74e45c3917" # AMI in London region
  instance_type          = "t2.medium"
  subnet_id              = aws_subnet.public_subnet_1.id
  vpc_security_group_ids = [aws_security_group.worker_security_group.id]
  key_name = var.key_name

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
