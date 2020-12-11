openssl req -newkey rsa:2048 -new -nodes -x509 -days 3650 -keyout osfx-key.pem -out osfx-cert.pem
kubectl create secret tls osfx-cert --key osfx-key.pem --cert osfx-cert.pem

kubectl apply -f 0_osfx_mandatory.yaml
kubectl apply -f 1_osfx_loadbalancer.yaml
kubectl apply -f 3_osfx_defaults.yaml

kubectl create namespace cert-manager
kubectl label namespace cert-manager certmanager.k8s.io/disable-validation=true
kubectl apply -f https://github.com/jetstack/cert-manager/releases/download/v1.1.0/cert-manager-no-webhook.yaml
kubectl apply -f 8_osfx_issuer_live.yaml
kubectl apply -f 9_osfx_ingress.yaml
kubectl describe ingress
kubectl describe certificate




cat <<EOF > test-cert-manager-resources.yaml
apiVersion: v1
kind: Namespace
metadata:
  name: cert-manager-test
---
apiVersion: certmanager.k8s.io/v1alpha1
kind: Issuer
metadata:
  name: test-selfsigned
  namespace: cert-manager-test
spec:
  selfSigned: {}
---
apiVersion: certmanager.k8s.io/v1alpha1
kind: Certificate
metadata:
  name: selfsigned-cert
  namespace: cert-manager-test
spec:
  commonName: example.com
  secretName: selfsigned-cert-tls
  issuerRef:
    name: test-selfsigned
EOF