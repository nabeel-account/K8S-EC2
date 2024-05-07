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
  default = "10.244.0.0/16"
}