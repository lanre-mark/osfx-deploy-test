install-multipass:
	snap install multipass

install-tools: 
	sudo apt install make

create-cluster: install-tools spin-kubernetes
	microk8s add-node
	
enable-loadbalancer:
	microk8s enable ingress
	microk8s enable metallb
	microk8s enable dns
	microk8s enable storage
	microk8s enable dashboard
	microk8s enable istio

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
	sudo snap install microk8s --classic --channel=1.18/stable
	sudo snap alias microk8s.kubectl kubectl
	sudo usermod -a -G microk8s ubuntu && sudo chown -f -R ubuntu ~/.kube
