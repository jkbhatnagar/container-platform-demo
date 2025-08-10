# sudo chmod +x be-notes_run.sh
# ./be-notes_run.sh

kubectl apply -f backend/k8s/deployment.yaml
kubectl apply -f backend/k8s/service.yaml

kubectl get pods -l app=note-api-deployment
kubectl get svc note-api-service

kubectl logs deploy/note-api-deployment -f

# --------- Run in a seperate terminal ---------
# kubectl port-forward svc/note-api-service 8080:80
# --------- Run in a seperate terminal ---------

# then use http://localhost:8080