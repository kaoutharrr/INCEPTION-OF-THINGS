#!/bin/bash
# 1. Wait for the server's token to appear in the shared folder
while [ ! -f /vagrant/node-token ]; do sleep 2; done

# 2. Join the cluster using the Server IP and Token [cite: 56]
TOKEN=$(cat /vagrant/node-token)
curl -sfL https://get.k3s.io | K3S_URL=https://192.168.56.110:6443 K3S_TOKEN=$TOKEN INSTALL_K3S_EXEC="--node-ip=192.168.56.111" sh -