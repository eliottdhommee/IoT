#! /bin/sh

kubectl create namespace gitlab
helm repo add gitlab https://charts.gitlab.io/
helm repo update
helm upgrade --install gitlab gitlab/gitlab  --timeout 800s --set global.edition=ce --set global.hosts.domain=example.com --set global.ingress.enabled=false --set nginx-ingress.enabled=false --set certmanager-issuer.email=eliottdhommee@gmail.com --namespace=gitlab
kubectl apply -f ../confs/gitlab-ingress.yaml -n gitlab
kubectl apply -f ../confs/argo-app.yaml -n argocd
IPEXT=`kubectl get ingress -n gitlab | grep gitlab | awk '{print $4}'`
echo "$IPEXT gitlab.example.com" | sudo tee -a  /etc/hosts
echo `kubectl get secret -n gitlab gitlab-gitlab-initial-root-password -ojsonpath='{.data.password}' | base64 --decode` > gitlab_password.txt
