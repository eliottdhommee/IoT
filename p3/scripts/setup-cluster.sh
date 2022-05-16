#! /bin/sh
#apt-get update
#apt-get install -y apt-transport-https ca-certificates curl software-properties-common
#curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
#add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable"
#apt-cache policy docker-ce
#apt-get install -y docker-ce
#
#wget -q -O - https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | bash
#
#curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
#install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

k3d cluster create part3 -p 8080:80@loadbalancer -p 8443:443@loadbalancer -p 4242:3006
kubectl create namespace argocd
kubectl create namespace dev
kubectl apply -f ../confs/install.yaml -n argocd
kubectl apply -f ../confs/ingress.yaml -n argocd
kubectl rollout status deployment argocd-server -n argocd
kubectl apply -f ../confs/argo-app.yaml -n argocd
echo `kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d ` > argocd-password.txt
