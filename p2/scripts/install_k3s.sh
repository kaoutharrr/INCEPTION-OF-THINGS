#!/bin/bash

echo "Installing k3s..."

#install K3s in server mode
curl -sfL https://get.k3s.io | sh -s - --write-kubeconfig-mode 644

echo "Wainting..."
sleep 30

kubectl wait --for=condition=Ready node --all --timeout=60s

echo "k3s installation completed"
