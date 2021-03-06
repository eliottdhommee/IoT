#! /bin/sh

#curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
#chmod 700 get_helm.sh
#./get_helm.sh

kubectl create namespace gitlab
helm repo add gitlab https://charts.gitlab.io/
helm repo update
helm upgrade --install gitlab gitlab/gitlab --version 5.10.0  --timeout 800s --set global.edition=ce  --set certmanager-issuer.email=eliottdhommee@gmail.com --namespace=gitlab -f ../confs/values.yaml
kubectl apply -f ../confs/gitlab-ingress.yaml -n gitlab
IPEXT=`kubectl get ingress -n gitlab | grep gitlab | awk '{print $4}'`
echo "$IPEXT gitlab.example.com" | sudo tee -a  /etc/hosts
echo `kubectl get secret -n gitlab gitlab-gitlab-initial-root-password -ojsonpath='{.data.password}' | base64 --decode` > gitlab-password.txt
