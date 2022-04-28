#! /bin/sh

kubectl create namespace gitlab
kubectl apply -f https://raw.githubusercontent.com/google/metallb/v0.8.3/manifests/metallb.yaml
IP=`kubectl get svc -n kube-system | grep traefik | awk '{ print $4 }'`
IPL=`echo $IP | awk -F. '{print $1"."$2"."$3".100"}'`
cat << EOF > metal-lb-layer2-config.yaml
apiVersion: v1
kind: ConfigMap
metadata:
  namespace: metallb-system
  name: config
data:
  config: |
    address-pools:
    - name: default
      protocol: layer2
      addresses:
      - $IP-$IPL
EOF
kubectl create -f metal-lb-layer2-config.yaml
helm repo add gitlab https://charts.gitlab.io/
helm repo update
helm upgrade --install gitlab gitlab/gitlab  -f https://gitlab.com/gitlab-org/charts/gitlab/-/raw/master/examples/values-gke-minimum.yaml --timeout 600s --set global.edition=ce --set global.hosts.domain=example.com   --set certmanager-issuer.email=eliottdhommee@gmail.com --namespace=gitlab 
IPEXT=`kubectl get service gitlab-nginx-ingress-controller -n gitlab |grep gitlab| awk '{print $4}'`
echo "$IPEXT gitlab.example.com" | sudo tee -a  /etc/hosts
echo `kubectl get secret -n gitlab gitlab-gitlab-initial-root-password -ojsonpath='{.data.password}' | base64 --decode` > gitlab_password.txt
