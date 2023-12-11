# deploy green environement
kubectl apply -f green.yml

# get DNS of green service
GREEN_URL=$(kubectl get svc green-svc -o jsonpath="{.status.loadBalancer.ingress[0].hostname}")

# Check deployment
STATUS_CHECK=$(kubectl rollout status deployment/green -n udacity | grep -c "successfully rolled out")
DNS_CHECK=$(curl -s -m 5 $GREEN_URL | grep -c "GREEN")

# Begin canary deployment
while [ $STATUS_CHECK -le 0 ] || [ $DNS_CHECK -le 0  ]
do
  echo "Verifying green service..."
  DNS_CHECK=$(curl -s -m 5 $GREEN_URL | grep -c "GREEN")
done

echo "Green deployment successful"
