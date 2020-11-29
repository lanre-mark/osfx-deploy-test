kubectl create namespace cert-manager
kubectl apply --validate=false -f https://github.com/jetstack/cert-manager/releases/download/v0.12.0/cert-manager.yaml
kubectl create -f osfx-cert-issuer.yaml
kubectl apply -f osfx-ingress.yaml
kubectl describe ingress
kubectl describe certificate

