#!/bin/bash

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${GREEN}=== ArgoCD Access Information ===${NC}"


ARGOCD_PASSWORD=$(kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d)

echo -e "${YELLOW}ArgoCD Admin Credentials:${NC}"
echo -e "Username: ${GREEN}admin${NC}"
echo -e "Password: ${GREEN}${ARGOCD_PASSWORD}${NC}"
echo ""

echo -e "${YELLOW}To access ArgoCD UI, run this command in a separate terminal:${NC}"
echo -e "${GREEN}kubectl port-forward svc/argocd-server -n argocd 8080:443${NC}"
echo ""
echo -e "${YELLOW}Then open your browser and go to:${NC}"
echo -e "${GREEN}https://localhost:8080${NC}"
echo -e "${YELLOW}(Accept the self-signed certificate warning)${NC}"
echo ""


read -p "Start port-forward now? (y/n) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo -e "${GREEN}Starting port-forward... Press Ctrl+C to stop${NC}"
    kubectl port-forward svc/argocd-server -n argocd 8080:443
fi