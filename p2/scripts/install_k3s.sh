#!/bin/bash

echo "Installing k3s..."

#install K3s in server mode
curl -sfL https://get.k3s.io/ | K3S_KUBECONFIG_MODE="644" INSTALL_K3S_EXEC="--flannel-iface eth1" sh -

echo "Wainting..."
sleep 30

kubectl wait --for=condition=Ready node --all --timeout=60s

echo "k3s installation completed"
