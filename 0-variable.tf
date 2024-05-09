variable "name" {
  description = "Project name"
  default = "eks-nodes"
}

variable "region" {
  description = "AWS region to deploy the cluster in"
  default = "us-east-1"
}

variable "key_name" {
  description = "Name of the AWS key pair"
  default = "cloudguru"
}

variable "pod-network-cidr" {
  description = "Kubernetes pod cidr network range"
  default = "10.244.0.0/16"
}

variable "ami" {
  description = "Amazon Machine Images for us-east-1"
  default = "ami-04b70fa74e45c3917"
}