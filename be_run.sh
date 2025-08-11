# sudo chmod +x be_run.sh
# ./be_run.sh

kubectl apply -f backend/k8s/secret.yaml
kubectl apply -f backend/k8s/configmap.yaml
kubectl apply -f backend/k8s/deployment.yaml
kubectl apply -f backend/k8s/service.yaml

kubectl get pods -l app=complaints-backend-deployment
kubectl get svc complaints-backend-service

# kubectl logs deploy/complaints-backend-deployment -f

# curl http://complaints-backend-service:80/complaints
# curl -X POST "http://172.20.37.53:80/complaints" \
# -H "Content-Type: application/json" \
# -d '{"category":"Billing","description":"Overcharged on last bill"}'

# kubectl run -it --rm --restart=Never busybox --image=busybox:1.28 -- nslookup complaints-backend-service