openssl req -newkey rsa:2048 -new -nodes -x509 -days 3650 -keyout osfx-key.pem -out osfx-cert.pem
kubectl create secret tls osfx-cert --key osfx-key.pem --cert osfx-cert.pem