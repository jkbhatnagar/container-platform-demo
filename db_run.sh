# git clone https://github.com/jkbhatnagar/container-platform-demo.git
# cd container-platform-demo/
# sudo chmod +x db_run.sh
# ./db_run.sh

kubectl apply -f database/k8s/configmap.yaml

kubectl apply -f database/k8s/deployment.yaml

kubectl apply -f database/k8s/service.yaml

kubectl get configmaps

kubectl get pods

kubectl get svc

# --------- Run in a seperate terminal ---------
# sudo apt update
# sudo apt install postgresql-client

# psql -h <ClusterIP> -U postgres -d complaints_db
# mysecretpassword
# select * from Complaints;
# \q
# --------- Run in a seperate terminal ---------
