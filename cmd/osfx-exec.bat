kubectl apply -f https://docs.projectcalico.org/manifests/calico.yaml
curl https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 > get_helm.sh
chmod 700 get_helm.sh
./get_helm.sh

kubectl apply -f pre_osfx.yaml
sudo kubectl config set-context osfx --namespace=osfx --cluster=kubernetes --user=kubernetes-admin

openssl req -newkey rsa:2048 -new -nodes -x509 -days 3650 -keyout osfx-key.pem -out osfx-cert.pem
kubectl create secret tls osfx-cert --key osfx-key.pem --cert osfx-cert.pem

kubectl apply -f 0_osfx_mandatory.yaml
kubectl apply -f 1_osfx_loadbalancer.yaml
kubectl apply -f 3_osfx_defaults.yaml

** https://cert-manager.io/docs/installation/kubernetes/ **
kubectl create namespace cert-manager
helm repo add jetstack https://charts.jetstack.io
helm repo update
helm install \
  cert-manager jetstack/cert-manager \
  --namespace cert-manager \
  --version v1.1.0 \
  --set installCRDs=true
kubectl apply -f 8_osfx_issuer_live.yaml
kubectl apply -f 9_osfx_ingress.yaml
kubectl describe ingress
kubectl describe certificate