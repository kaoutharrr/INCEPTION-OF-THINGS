#!/bin/bash

echo "Starting deployment of applications..."

sleep 10

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