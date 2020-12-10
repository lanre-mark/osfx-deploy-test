openssl req -newkey rsa:2048 -new -nodes -x509 -days 3650 -keyout osfx-key.pem -out osfx-cert.pem
kubectl create secret tls osfx-cert --key osfx-key.pem --cert osfx-cert.pem

kubectl apply -f 0_osfx_mandatory.yaml
kubectl apply -f 1_osfx_loadbalancer.yaml
kubectl apply -f 3_osfx_defaults.yaml

kubectl create namespace cert-manager
kubectl apply -f https://github.com/jetstack/cert-manager/releases/download/v1.1.0/cert-manager.yaml
kubectl apply -f 8_osfx_issuer_live.yaml
kubectl apply -f 9_osfx_ingress.yaml
kubectl describe ingress
kubectl describe certificate