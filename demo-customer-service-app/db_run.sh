# cd container-platform-demo/demo-customer-service-app/database/

kubectl create configmap postgres-initdb --from-file=container-platform-demo/demo-customer-service-app/database/init.sql

kubectl apply -f container-platform-demo/demo-customer-service-app/database/db_deployment.yaml

kubectl apply -f platform-demo/demo-customer-service-app/database/db_service.yaml

sleep 15

kubectl port-forward svc/postgres-service 5432:5432

kubectl get pods

kubectl get svc

sudo apt install postgresql-client
