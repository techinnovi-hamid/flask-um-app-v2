#!/bin/bash
set -e

# Update packages
apt update -y

# Install required packages
apt install -y docker.io git curl

# Start Docker
systemctl enable docker
systemctl start docker
usermod -aG docker ubuntu

# Install kubectl
curl -LO https://dl.k8s.io/release/v1.31.0/bin/linux/amd64/kubectl
install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

# Install Kind
curl -Lo /usr/local/bin/kind https://kind.sigs.k8s.io/dl/v0.23.0/kind-linux-amd64
chmod +x /usr/local/bin/kind

# Wait for Docker
sleep 20

# Create cluster
kind create cluster --name devops-cluster

# Configure kubeconfig for ubuntu user
mkdir -p /home/ubuntu/.kube
kind get kubeconfig --name devops-cluster > /home/ubuntu/.kube/config
chown -R ubuntu:ubuntu /home/ubuntu/.kube

# Clone repo as ubuntu user
sudo -u ubuntu bash << 'EOF'
cd /home/ubuntu
git clone https://github.com/techinnovi-hamid/flask-um-app-v2.git
cd flask-um-app-v2

# Wait for Kubernetes API
sleep 30

kubectl apply -f k8s/
EOF

echo "Deployment completed"
