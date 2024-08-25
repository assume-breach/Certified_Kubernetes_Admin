#!/bin/bash/
if [ "$(id -u)" -ne 0 ]; then
echo "This Script Must Be Run As ROOT"
exit 1
fi
echo "Setting Hostname"
sudo hostnamectl set-hostname kubecontrol
echo ""
echo "Creating LocalHost Passwordless SSH"
ssh-keygen -t rsa -b 4096 -f ~/.ssh/id_rsa -N "" <<< ""
cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys
chmod 600 ~/.ssh/authorized_keys
echo ""
echo "Passwordless SSH setup is complete."
echo ""
echo "Installing Necessary Packages"
apt install ansible-core curl openssh-server net-tools open-vm-tools open-vm-tools-desktop -y
echo "user ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/user
echo ""
echo "Creating Ansible Directory"
mkdir -p /home/user/ansible
echo ""
echo "[defaults]" >> /home/user/ansible/ansible.cfg
echo "inventory = /home/user/ansible/inventory" >> /home/user/ansible/ansible.cfg
echo "remote_user = user" >> /home/user/ansible/ansible.cfg
echo "host_key_checking = false" >> /home/user/ansible/ansible.cfg
echo "[privilege_escalation]" >> /home/user/ansible/ansible.cfg
echo "become = true" >> /home/user/ansible/ansible.cfg
echo "become_user = root" >> /home/user/ansible/ansible.cfg
echo "become_method = sudo" >> /home/user/ansible/ansible.cfg
echo "become_ask_pass = false" >> /home/user/ansible/ansible.cfg
echo "[control]" >> /home/user/ansible/inventory 
echo "kubecontrol" >> /home/user/ansible/inventory
echo "[workers]" >> /home/user/ansible/inventory
echo "worker1 ansible_user=user ansible_ssh_private_key_file=~/.ssh/id_rsa
" >> /home/user/ansible/inventory
echo "worker2 ansible_user=user ansible_ssh_private_key_file=~/.ssh/id_rsa
" >> /home/user/ansible/inventory
echo ""
echo "What Is Your Local IP? This Will Be The Control Node IP"
read kubecontrol
echo ""
echo "What Is The IP For Worker1?"
read worker1
echo ""
echo "What Is The IP For Worker2?"
read worker2
echo ""
echo "$kubecontrol kubecontrol" >> /etc/hosts
echo "$worker1 worker1" >> /etc/hosts
echo "$worker2 worker2" >> /etc/hosts
echo "Creating SSH Keys"
echo ""
# Generate SSH key for user 'user'

sudo -u user ssh-keygen -t rsa -b 4096 -f /home/user/.ssh/id_rsa -N ""

# Copy the SSH key to worker1 and worker2
sudo -i -u user ssh-copy-id worker1
sudo -i -u user ssh-copy-id worker2
ssh user@worker1 "sudo hostnamectl set-hostname worker1"
ssh user@worker2 "sudo hostnamectl set-hostname worker2"


curl -o /home/user/ansible/kube.yml https://raw.githubusercontent.com/assume-breach/Certified_Kubernetes_Admin/main/kube.yml
cd /home/user/ansible/
