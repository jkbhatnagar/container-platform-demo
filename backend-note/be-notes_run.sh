# hostnamectl

# docker ps -a
# docker stop <>
# docker container rm <>

# docker image ls
# docker image rm <>

# docker build --platform linux/amd64 https://github.com/jkbhatnagar/container-platform-demo.git#main:backend-note -t jatinbhatnagar/container-platform-demo-backend-notesapp-nodejs:v0.1
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
# note down the cluster ip from output
# NAME               TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)   AGE
# note-api-service   ClusterIP   172.20.168.181   <none>        80/TCP    5s

# curl http://ClusterIP:80/notes
# curl -X POST "http://ClusterIP:80/notes" \
# -H "Content-Type: application/json" \
# -d '{"title":"note1","content":"Overcharged on last bill"}'

kubectl get pods -o wide
# note down the pod ips from output
# NAME                                   READY   STATUS    RESTARTS   AGE   IP           NODE     NOMINATED NODE   READINESS GATES
# note-api-deployment-64fc88c7b6-9qmfk   1/1     Running   0          20m   172.17.1.3   node01   <none>           <none>
# note-api-deployment-64fc88c7b6-fskmq   1/1     Running   0          20m   172.17.1.2   node01   <none>           <none>

# curl http://<podip>:3000/notes
# curl -X POST "http://ClusterIP:3000/notes" \
# -H "Content-Type: application/json" \
# -d '{"title":"note1","content":"Overcharged on last bill"}'




# Debugging
# kubectl logs deploy/note-api-deployment -f
# kubectl logs note-api-deployment -n default --previous
# kubectl logs services <service_name>
# kubectl describe pod note-api-deployment
# kubectl delete -f backend-note/k8s/deployment.yaml
# kubectl delete -f backend-note/k8s/service.yaml
