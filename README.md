# Creating Kubernetes using EC2

This work is based on the following article: https://mrmaheshrajput.medium.com/deploy-kubernetes-cluster-on-aws-ec2-instances-f3eeca9e95f1

## Assumptions
- You have created a keypair name cloudguru

## Limitations
- You must manually join the worker nodes using "kubeadm join".
- You can extract the "kubeadm join" command from the control-plane `/var/log/cloud-init-output.log` or by running `kubeadm token create --print-join-command` in the node hosting the control plane.
- This can be overcome through the use of ansible for provisioning
- If a connection between the control-plane and a worker node is terminated, you can reset admin using `kubeadm reset`
- node group and control plane ports are accessible to all
- We have used Instance profile to connect the ingress controller with within the EC2 with AWS application load balancer. Normally, through the use of EKS, kubernetes and AWS resources are connected via OpenID Connect (OIDC) 
which runs the IAM roles for service accounts (IRSA) functionality with the kubernetes cluster. However, since we are manually deploying the Kubernetes cluster using kubeadm, we would have needed to install our own OpenID Connect.
As an alternative to using, OIDC, a simply method to achiving IRSA is using instance profile. This will grant the node workers the necessary permissions to interact with AWS Application load balancer.

## Improvements
- Good template for user data: https://github.com/Ahmad-Faqehi/Terraform-Bulding-K8S/blob/main/scripts/install_k8s_msr.sh
- Due to the missing OIDC, connectivity to AWS resources and in paticular the application load balancer from the Ingress Controller is work in progress