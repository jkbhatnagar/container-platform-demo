kubectl apply -f database/k8s/configmap.yaml
kubectl apply -f database/k8s/deployment.yaml
kubectl apply -f database/k8s/service.yaml
kubectl get configmap -n container-platform-demo complaints-postgres-initdb
kubectl get pods -n container-platform-demo -l app=complaints-postgres-deployment
kubectl get svc -n container-platform-demo complaints-postgres-service

# --------- Run in a seperate terminal ---------
# sudo apt update
# sudo apt install postgresql-client

# psql -h <ClusterIP> -U postgres -d complaints_db
# mysecretpassword
# select * from Complaints;
# \q
# --------- Run in a seperate terminal ---------
