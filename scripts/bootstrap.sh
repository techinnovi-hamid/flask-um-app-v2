#!/bin/bash

apt update -y

apt install -y docker.io git curl

systemctl enable docker
systemctl start docker

curl -LO "https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl"

chmod +x kubectl
mv kubectl /usr/local/bin/

curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.23.0/kind-linux-amd64

chmod +x kind
mv kind /usr/local/bin/

kind create cluster --name devops-cluster
