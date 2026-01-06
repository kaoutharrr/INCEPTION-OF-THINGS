#!/bin/bash

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}=== Starting Installation ===${NC}"

# Update system
echo -e "${YELLOW}Updating system...${NC}"
sudo apt-get update

# Install Docker
echo -e "${YELLOW}Installing Docker...${NC}"
if ! command -v docker &> /dev/null; then
    sudo apt-get install -y \
        ca-certificates \
        curl \
        gnupg \
        lsb-release
    
    sudo mkdir -p /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
    
    echo \
      "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
      $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    
    sudo apt-get update
    sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin
    
    # Add current user to docker group
    sudo usermod -aG docker $USER
    echo -e "${GREEN}Docker installed successfully${NC}"
else
    echo -e "${GREEN}Docker already installed${NC}"
fi

# Install kubectl
echo -e "${YELLOW}Installing kubectl...${NC}"
if ! command -v kubectl &> /dev/null; then
    curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
    sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
    rm kubectl
    echo -e "${GREEN}kubectl installed successfully${NC}"
else
    echo -e "${GREEN}kubectl already installed${NC}"
fi

# Install K3d
echo -e "${YELLOW}Installing K3d...${NC}"
if ! command -v k3d &> /dev/null; then
    curl -s https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | bash
    echo -e "${GREEN}K3d installed successfully${NC}"
else
    echo -e "${GREEN}K3d already installed${NC}"
fi

echo -e "${GREEN}=== Installation Complete ===${NC}"
echo -e "${YELLOW}Note: If Docker was just installed, you may need to log out and back in for group changes to take effect${NC}"
echo -e "${YELLOW}Or run: newgrp docker${NC}"

# Verify installations
echo -e "${GREEN}=== Verifying Installations ===${NC}"
docker --version
kubectl version --client
k3d --version