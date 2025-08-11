kubectl apply -f frontend/k8s/deployment.yaml
kubectl apply -f frontend/k8s/service.yaml

kubectl get pods -n container-platform-demo -l app=complaints-frontend
kubectl get svc -n container-platform-demo complaints-frontend

# kubectl port-forward svc/complaints-frontend 8080:80

