#! /bin/sh

k3d cluster create part3 -p 8080:80@loadbalancer -p 8443:443@loadbalancer -p 4242:3006
kubectl create namespace argocd
kubectl create namespace dev
kubectl apply -f ../confs/install.yaml -n argocd
kubectl apply -f ../confs/ingress.yaml -n argocd
kubectl apply -f ../confs/argo-app.yaml -n argocd
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d && echo
