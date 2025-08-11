

kubectl apply -f frontend/k8s/deployment.yaml
kubectl apply -f frontend/k8s/service.yaml

kubectl get pods -l app=complaints-frontend
kubectl get svc complaints-frontend

# kubectl port-forward svc/complaints-frontend 8080:80

