# sudo chmod +x be_run.sh
# ./be_run.sh

kubectl apply -f k8s/secret.yaml        # only if using the file version
kubectl apply -f k8s/configmap.yaml
kubectl apply -f k8s/deployment.yaml
kubectl apply -f k8s/service.yaml

kubectl get pods -l app=complaints-backend-deployment
kubectl get svc complaints-backend-service

kubectl logs deploy/complaints-backend-service -f

# --------- Run in a seperate terminal ---------
# kubectl port-forward svc/complaints-service 8080:80
# --------- Run in a seperate terminal ---------

# then use http://localhost:8080