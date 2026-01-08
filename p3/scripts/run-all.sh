#!/bin/bash
# Master script to initialize Part 3 infrastructure

./scripts/setup.sh
./scripts/create-cluster.sh
./scripts/create-namespaces.sh
./scripts/install-argocd.sh

echo "Infrastructure is ready. Applying application..."
kubectl apply -f confs/application.yaml

./scripts/access-argocd.sh