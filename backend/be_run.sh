kubectl apply -f backend/k8s/secret.yaml
kubectl apply -f backend/k8s/configmap.yaml
kubectl apply -f backend/k8s/deployment.yaml
kubectl apply -f backend/k8s/service.yaml

kubectl get secret -n container-platform-demo complaints-backend-secret -o yaml
kubectl get configmap -n container-platform-demo complaints-backend-config
kubectl get pods -n container-platform-demo -l app=complaints-backend-deployment
kubectl get svc -n container-platform-demo complaints-backend-service

# kubectl port-forward svc/complaints-backend-service -n container-platform-demo 8080:80
# kubectl logs deploy/complaints-backend-deployment -f

# curl http://localhost:8080/complaints
# curl -X POST "http://localhost:8080/complaints" \
# -H "Content-Type: application/json" \
# -d '{"category":"Billing","description":"Overcharged on last bill"}'

# kubectl run -it --rm --restart=Never busybox --image=busybox:1.28 -- nslookup complaints-backend-service