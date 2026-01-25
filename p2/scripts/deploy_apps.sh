#!/bin/bash

echo "Starting deployment of applications..."

echo "Checking files..."
ls -la /vagrant/confs/

sleep 10

if [ ! -f /vagrant/confs/app1-deployment.yaml ]; then
    echo "ERROR: Files not found in /vagrant/confs/"
    exit 1
fi

kubectl apply -f /vagrant/confs/app1-deployment.yaml
kubectl apply -f /vagrant/confs/app2-deployment.yaml
kubectl apply -f /vagrant/confs/app3-deployment.yaml

kubectl apply -f /vagrant/confs/ingress.yaml

echo "Waiting..."
kubectl wait --for=condition=available --timeout=120s deployment/app-one
kubectl wait --for=condition=available --timeout=120s deployment/app-two
kubectl wait --for=condition=available --timeout=120s deployment/app-three

echo "Applications deployed successfully."

echo "=== Pods ==="
kubectl get pods

echo "=== Services ==="
kubectl get services

echo "=== Ingresses ==="
kubectl get ingresses