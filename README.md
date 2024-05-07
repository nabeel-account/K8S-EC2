# Creating Kubernetes using EC2

This work is based on the following article: https://mrmaheshrajput.medium.com/deploy-kubernetes-cluster-on-aws-ec2-instances-f3eeca9e95f1

## Assumptions
- You have created a keypair name cloudguru

## Limitations
- You must extract the " kubeadm join" command from the control-plane `/var/log/cloud-init-output.log`
- This can be overcome through the use of ansible for provisioning
- If a connection between the control-plane and a worker node is terminated, you can reset admin using `kubeadm reset `