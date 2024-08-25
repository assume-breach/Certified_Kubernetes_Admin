# Certified Kubernetes Admin
Here is a setup script and an ansible playbook to set up a 3 node kubernetes cluster (1 control node 2 worker nodes) in working toward the cKa certification.

Step 1:
Spin up 1 Ubuntu VM. When configuring the VM create a user named "user". This going to be your ansible/sudo user.

Step 2:
Su to root and run these commands in your terminal.

echo "user ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/user;
apt install openssh-server -y; systemctl start ssh; systemctl enable ssh


Step 3:
Clone the VM 2 times and then run the user_ssh.sh script WITHOUT SUDO. Run setup.sh script WITH SUDO on your control node. You will need to get the IPs of each VM.

Step 4:
CD to /home/user/ansible and run ansible-playbook kube.yml

Step 5:
Verify your kubernetes cluster. kubectl get nodes
