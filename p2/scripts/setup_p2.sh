#!/bin/bash

# Update the package list and install curl
sudo apt-get update -y
sudo apt-get install -y curl

# Install K3s in server mode
curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="--node-ip=192.168.56.110" sh -

# Wait for the config file to be created by K3s
sleep 5

# Ensure kubectl can be used without sudo
sudo chmod 644 /etc/rancher/k3s/k3s.yaml