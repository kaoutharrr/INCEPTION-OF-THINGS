#!/bin/bash

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

CLUSTER_NAME="iot-cluster"

echo -e "${YELLOW}Creating K3d cluster: ${CLUSTER_NAME}${NC}"


k3d cluster delete ${CLUSTER_NAME} 2>/dev/null


k3d cluster create ${CLUSTER_NAME} \
    --port 8888:8888@loadbalancer \
    --port 8080:8080@loadbalancer \
    --agents 1

echo -e "${GREEN}Cluster created successfully${NC}"


kubectl config use-context k3d-${CLUSTER_NAME}


echo -e "${YELLOW}Waiting for cluster to be ready...${NC}"
kubectl wait --for=condition=Ready nodes --all --timeout=60s

echo -e "${GREEN}Cluster is ready!${NC}"
kubectl get nodes