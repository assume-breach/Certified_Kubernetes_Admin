# Certified Kubernetes Admin
Here is a setup script and an ansible playbook to set up a 3 node kubernetes cluster (1 control node 2 worker nodes) in working toward the cKa certification.
Step 1:
Spin up 1 Ubuntu VM. When configuring the VM create a user named "user". This going to be your ansible/sudo user.

Step 2:
Su to root and paste this command into your terminal.

echo "user ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/user

Step 3:
Run the setup.sh script.

Step 4:
CD to /home/user/ansible and run ansible-playbook kube.yml

Step 5:
Verify your kubernetes cluster. kubectl get nodes
