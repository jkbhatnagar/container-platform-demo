# docker build https://github.com/jkbhatnagar/container-platform-demo.git#main:backend-note -t jatinbhatnagar/container-platform-demo-backend-notesapp-nodejs:v0.1
# docker login -u jatinbhatnagar
# docker push jatinbhatnagar/container-platform-demo-backend-notesapp-nodejs:v0.1

# git clone https://github.com/jkbhatnagar/container-platform-demo.git
# cd container-platform-demo/
# sudo chmod +x be-notes_run.sh
# ./be-notes_run.sh

kubectl apply -f backend-note/k8s/deployment.yaml
kubectl apply -f backend-note/k8s/service.yaml

kubectl get pods -l app=note-api-deployment
kubectl get svc note-api-service

kubectl logs deploy/note-api-deployment -f

# kubectl logs note-api-deployment -n default --previous
# kubectl describe pod note-api-deployment
# kubectl delete -f backend-note/k8s/deployment.yaml
# kubectl delete -f backend-note/k8s/service.yaml
# --------- Run in a seperate terminal ---------
# kubectl port-forward svc/note-api-service 8080:80
# --------- Run in a seperate terminal ---------

# then use http://localhost:8080