install-multipass:
	snap install multipass
create-master:
	multipass launch -m 4Gb -n osfx-master
	multipass shell osfx-master

install-tools:
	sudo apt install make

create-cluster: install-tools
	sudo snap install microk8s --classic --channel=1.18/stable
	sudo snap alias microk8s.kubectl kubectl
	sudo usermod -a -G microk8s ubuntu | sudo chown -f -R ubuntu ~/.kube
	microk8s add-node
	
enable-loadbalancer:
	microk8s enable ingress-

create-node-2:
	multipass launch -m 4Gb -n osfx-node-2

create-node-3:
	multipass launch -m 4Gb -n osfx-node-3
