#!/bin/bash

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${YELLOW}Installing ArgoCD...${NC}"


kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

echo -e "${YELLOW}Waiting for ArgoCD pods to be ready (this may take a few minutes)...${NC}"

kubectl wait --for=condition=Ready pods --all -n argocd --timeout=300s

if [ $? -eq 0 ]; then
    echo -e "${GREEN}ArgoCD installed successfully!${NC}"
    echo -e "${YELLOW}Checking pods:${NC}"
    kubectl get pods -n argocd
else
    echo -e "${RED}Some pods are not ready. Checking status:${NC}"
    kubectl get pods -n argocd
fi