#!/bin/bash

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${YELLOW}Creating namespaces...${NC}"


kubectl create namespace argocd
echo -e "${GREEN}Created namespace: argocd${NC}"


kubectl create namespace dev
echo -e "${GREEN}Created namespace: dev${NC}"

echo -e "${YELLOW}Verifying namespaces:${NC}"
kubectl get namespaces | grep -E "argocd|dev"