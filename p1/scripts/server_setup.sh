#!/bin/bash
# 1. Install K3s and allow the config file to be read by the 'vagrant' user
curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="--write-kubeconfig-mode 644 --bind-address=192.168.56.110 --node-ip=192.168.56.110" sh -

# 2. Create a symlink so 'kubectl' works directly as requested [cite: 63]
sudo ln -s /usr/local/bin/k3s /usr/local/bin/kubectl

# 3. Save the token to the shared folder so the Worker can join
sudo cat /var/lib/rancher/k3s/server/node-token > /vagrant/node-token