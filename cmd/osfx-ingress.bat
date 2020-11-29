    
kubectl create -f 0_osfx_mandatory.yaml
kubectl create -f 1_osfx_loadbalancer.yaml
kubectl create -f 2_osfx_dns.yaml
kubectl create -f 3_osfx_defaults.yaml

kubectl create namespace cert-manager
kubectl apply --validate=false -f https://github.com/jetstack/cert-manager/releases/download/v0.12.0/cert-manager.yaml
kubectl create -f osfx-cert-issuer.yaml
kubectl apply -f osfx-ingress.yaml
kubectl describe ingress
kubectl describe certificate

kubectl apply --validate=false -f 10_.yaml
