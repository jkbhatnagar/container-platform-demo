# git clone https://github.com/jkbhatnagar/container-platform-demo.git
# cd container-platform-demo/demo-customer-service-app/
# sudo chmod +x db_run.sh
# ./db_run.sh

kubectl create configmap postgres-initdb --from-file=./database/init.sql

kubectl apply -f database/db_deployment.yaml

kubectl apply -f database/db_service.yaml

sleep 5

# kubectl port-forward svc/postgres-service 5432:5432

kubectl get pods

kubectl get svc

sudo apt install postgresql-client
