# Based on: https://docs.aws.amazon.com/eks/latest/userguide/lbc-helm.html

resource "aws_iam_role" "alb_ingress_controller" {
  name = "ALBIngressControllerRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Effect = "Allow"
        Sid    = ""
      },
    ],


    # THIS REQUIRES THE USE OF OIDC WHICH MUST BE MANUALLY SET FOR KUBERNETES CLUSTER BUILT WITH KUBEADM TO FUNCTION WITH AWS ALB
    # Statement = [
    #   {
    #     Effect = "Allow"
    #     Principal = {
    #       Federated = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:oidc-provider/oidc.eks.${var.region}.amazonaws.com/id/${data.aws_eks_cluster.cluster.identity[0].oidc[0].issuer}"
    #     }
    #     Action = "sts:AssumeRoleWithWebIdentity"
    #     Condition = {
    #       StringEquals = {
    #         "${data.aws_eks_cluster.cluster.identity[0].oidc[0].issuer}:sub" = "system:serviceaccount:kube-system:aws-load-balancer-controller"
    #       }
    #     }
    #   },
    # ]
  })
}

resource "aws_iam_role_policy_attachment" "alb_ingress_controller_policy" {
  role       = aws_iam_role.alb_ingress_controller.name
  policy_arn = aws_iam_policy.alb_ingress_controller.arn
}

resource "aws_iam_role_policy_attachment" "alb_ingress_controller_additional_policy" {
  role       = aws_iam_role.alb_ingress_controller.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}


# INSTEAD OF OIDC, WE WILL USE INSTANCE PROFILES TO CONNECT INGRESS CONTROLLER (INSIDE EC2 INSTANCES) WITH ALB

resource "aws_iam_instance_profile" "node_workers" {
  name = "instance_ingress_controller_profile"
  role = aws_iam_role.alb_ingress_controller.name
}
