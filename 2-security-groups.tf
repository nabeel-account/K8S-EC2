# The following ports are based on Kubernetes Requirements: https://kubernetes.io/docs/reference/networking/ports-and-protocols/

###############################################################################################################################################
# CONTROL PLANE SECURITY GROUPS
###############################################################################################################################################

# Control Plane security Group
resource "aws_security_group" "controlplane_security_group" {
  name        = "controlplane_security_group"
  description = "allow all essential kubernetes network traffic"
  vpc_id      = aws_vpc.vpc.id

  tags = {
    Name = "controlplane_security_group"
  }
}

# Create the security group block INGRESS Rules

## Please note, for added security, ensure you only specify the necessary cidr_ipv4 block

resource "aws_vpc_security_group_ingress_rule" "allow_ssh" {
  security_group_id = aws_security_group.controlplane_security_group.id
  description       = "SSH - port 22 so that we can ssh from our local machine to control plane"
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "tcp"
  from_port         = 22
  to_port           = 22
}

resource "aws_vpc_security_group_ingress_rule" "allow_kubeapi" {
  security_group_id = aws_security_group.controlplane_security_group.id
  description       = "Kubernetes API server"
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "tcp"
  from_port         = 6443
  to_port           = 6443
}

resource "aws_vpc_security_group_ingress_rule" "allow_etcd" {
  security_group_id = aws_security_group.controlplane_security_group.id
  description       = "etcd server client API. Private network only"
  cidr_ipv4         = aws_vpc.vpc.cidr_block
  ip_protocol       = "tcp"
  from_port         = 2379
  to_port           = 2380
}

resource "aws_vpc_security_group_ingress_rule" "allow_kube_kubelet_scheduler_controller" {
  security_group_id = aws_security_group.controlplane_security_group.id
  description       = "kubelet, kube-scheduler, and kube-controller. On private network only"
  cidr_ipv4         = aws_vpc.vpc.cidr_block
  ip_protocol       = "tcp"
  from_port         = 10250
  to_port           = 10259
}


# Create the security group block EGRESS Rules

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.controlplane_security_group.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}



###############################################################################################################################################
# WORKER NODE SECURITY GROUPS
###############################################################################################################################################

# Control Plane security Group
resource "aws_security_group" "worker_security_group" {
  name        = "worker_security_group"
  description = "allow all essential kubernetes worker node network traffic"
  vpc_id      = aws_vpc.vpc.id

  tags = {
    Name = "worker_security_group"
  }
}

# Create the security group block INGRESS Rules

## Please note, for added security, ensure you only specify the necessary cidr_ipv4 block

resource "aws_vpc_security_group_ingress_rule" "allow_ssh_worker" {
  security_group_id = aws_security_group.worker_security_group.id
  description       = "SSH - port 22 so that we can ssh from our local machine to worker nodes"
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "tcp"
  from_port         = 22
  to_port           = 22
}

resource "aws_vpc_security_group_ingress_rule" "allow_kubelet_kubeproxy_worker" {
  security_group_id = aws_security_group.worker_security_group.id
  description       = "Kubelet API and kube-proxy"
  cidr_ipv4         = aws_vpc.vpc.cidr_block
  ip_protocol       = "tcp"
  from_port         = 10250
  to_port           = 10256
}

resource "aws_vpc_security_group_ingress_rule" "allow_node_port_worker" {
  security_group_id = aws_security_group.worker_security_group.id
  description       = "Default NodePort Services range"
  cidr_ipv4         = aws_vpc.vpc.cidr_block
  ip_protocol       = "tcp"
  from_port         = 30000
  to_port           = 32767
}


# Create the security group block EGRESS Rules

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4_worker" {
  security_group_id = aws_security_group.worker_security_group.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}