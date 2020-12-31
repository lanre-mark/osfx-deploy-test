CLUSTER-PERMISSIONS=--clusterrole=cluster-admin  --user=admin  --user=kubelet
CLUSTER-GROUP= --group=system:serviceaccounts
install-multipass:
	snap install multipass

install-tools: 
	sudo apt install make

create-cluster: install-tools spin-kubernetes
	
add-node: 
	microk8s add-node
add-permission:
	kubectl create clusterrolebinding permissive-binding ${CLUSTER-PERMISSIONS} ${CLUSTER-GROUP}
configure-network:
	microk8s enable dns ingress istio storage metallb
	microk8s enable dashboard
	kubectl create namespace osfx
	kubectl create namespace ingress-nginx
	kubectl apply -f osfx-ingress.yaml

configure-dns:
	sudo snap install jq
	bash dns-deploy.sh -t osfx-dns.yaml

create-master: install-multipass
	multipass launch -m 4Gb -n osfx-master
	multipass shell osfx-master

create-node-1:
	multipass launch -m 4Gb -n osfx-node-1
	multipass shell osfx-node-1

create-node-2:
	multipass launch -m 4Gb -n osfx-node-2
	multipass shell osfx-node-2

create-node-3:
	multipass launch -m 4Gb -n osfx-node-3
	multipass shell osfx-node-3

spin-kubernetes:
	sudo snap install microk8s --classic --channel=1.19/stable
	sudo snap alias microk8s.kubectl kubectl
	sudo usermod -a -G microk8s ubuntu
	sudo chown -f -R ubuntu ~/.kube
	exit
cluster-ip:
	kubectl get service --namespace kube-system kube-dns -o jsonpath="{.spec.clusterIP}"