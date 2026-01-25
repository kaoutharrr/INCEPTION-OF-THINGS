#!/bin/bash

echo "=== Test des 3 replicas de app2 ==="
echo ""

echo "1. Pods app-two en cours d'exécution:"
kubectl get pods | grep app-two
echo ""

echo "2. Configuration du deployment (replicas):"
kubectl get deployment app-two -o jsonpath='{.spec.replicas}'
echo " replicas configurés"
echo ""

echo "3. Test de load balancing avec curl (15 requêtes):"
for i in {1..15}; do 
  POD_NAME=$(curl -s -H "Host: app2.com" http://192.168.56.110 | grep -oP 'pod:</td>\s*<td><b>\K[^<]+' | head -1)
  echo "Requête $i: $POD_NAME"
  sleep 0.3
done
echo ""

echo "4. Comptage des réponses par pod:"
for i in {1..30}; do 
  curl -s -H "Host: app2.com" http://192.168.56.110 | grep -oP 'pod:</td>\s*<td><b>\K[^<]+'
done | sort | uniq -c