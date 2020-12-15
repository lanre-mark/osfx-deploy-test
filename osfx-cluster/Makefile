DOCKER-REPO = https://download.docker.com/linux/ubuntu
DAEMON-JSON='{"exec-opts": ["native.cgroupdriver=systemd"],"log-driver": "json-file","log-opts": {"max-size": "100m"	},"storage-driver": "overlay2"}'
KUBE-CONFIG='net.bridge.bridge-nf-call-ip6tables = 1\nnet.bridge.bridge-nf-call-iptables = 1\nnet.ipv4.ip_forward = 1'
CLUSTER-DNS=osfx-cluster.osfx.etz
#sudo netstat -tulpn | grep kubelet
#sudo rm -r /var/lib/etcd
step1:
	sudo apt update
	sudo apt -y upgrade && sudo systemctl reboot

create-cluster:	install-kube-tools configure-env install-runtime create-and-validate

install-kube-tools: install-helm
	sudo apt install curl apt-transport-https
    curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
    echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list
	sudo apt update
	sudo apt -y install git curl wget kubelet kubeadm kubectl
	sudo apt-mark hold kubelet kubeadm kubectl
	sudo apt install make make-guile

install-helm:
	curl https://baltocdn.com/helm/signing.asc | sudo apt-key add -
	sudo apt-get install apt-transport-https --yes
	echo "deb https://baltocdn.com/helm/stable/debian/ all main" | sudo tee /etc/apt/sources.list.d/helm-stable-debian.list
	sudo apt-get update
	sudo apt-get install helm
	helm repo add fluxcd https://charts.fluxcd.io

configure-env:	disable-swap configure-ctl

disable-swap:
	sudo sed -i '/ swap / s/^\(.*\)$$/#\1/g' /etc/fstab
	sudo swapoff -a

configure-ctl:
	sudo modprobe overlay
	sudo modprobe br_netfilter

	@echo ${KUBE-CONFIG} | sudo tee /etc/sysctl.d/kubernetes.conf
	sudo sysctl --system

install-runtime: install-docker 
	#install-containerd

install-docker: download-docker create-docker-dir create-daemon-json start-docker-service
    # Add repo and Install packages
download-docker:
	sudo apt install -y curl gnupg2 software-properties-common apt-transport-https ca-certificates
	curl -fsSL ${DOCKER-REPO}/gpg | sudo apt-key add -
	sudo add-apt-repository "deb [arch=amd64] ${DOCKER-REPO} $$(lsb_release -cs) stable"
	sudo apt update
	sudo apt install -y containerd.io docker-ce docker-ce-cli

create-docker-dir:
	sudo mkdir -p /etc/systemd/system/docker.service.d

create-daemon-json:
	# Create daemon json config file
	@echo ${DAEMON-JSON} | sudo tee /etc/docker/daemon.json	

	# Start and enable Services
start-docker-service:
	sudo systemctl daemon-reload 
	sudo systemctl restart docker
	sudo systemctl enable docker
	
#Installing CRI-O:
install-crio-o: load-modules setup-ip download-crio-o start-crio-service
load-modules:
	# Ensure you load modules
	sudo modprobe overlay
	sudo modprobe br_netfilter

setup-ip:
	# Set up required sysctl params
	@echo ${KUBE-CONFIG} | sudo tee /etc/sysctl.d/kubernetes.conf
	
	# Reload sysctl
	sudo sysctl --system

	# Add repo
download-crio-o:
	. /etc/os-release
	sudo sh -c "echo 'deb http://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable/x${NAME}_${VERSION_ID}/ /' > /etc/apt/sources.list.d/devel:kubic:libcontainers:stable.list"
	wget -nv https://download.opensuse.org/repositories/devel:kubic:libcontainers:stable/x${NAME}_${VERSION_ID}/Release.key -O- | sudo apt-key add -
	sudo apt update
	# Install CRI-O
	sudo apt install cri-o-1.17
start-crio-service:
	# Start and enable Service
	sudo systemctl daemon-reload
	sudo systemctl start crio
	sudo systemctl enable crio

install-containerd: containerd-modules containerd-runtime containerd-ip containerd-install
	echo "Installing Containerd ..."
	# Configure persistent loading of modules
	@echo 'overlay\nbr_netfilter' | sudo tee /etc/modules-load.d/containerd.conf	

	# Load at runtime
	sudo modprobe overlay
	sudo modprobe br_netfilter

	# Ensure sysctl params are set
	@echo ${KUBE-CONFIG} | sudo tee /etc/sysctl.d/kubernetes.conf

	# Reload configs
	sudo sysctl --system
	# Install required packages
	sudo apt install -y curl gnupg2 software-properties-common apt-transport-https ca-certificates


	# Add Docker repo
	curl -fsSL ${DOCKER-REPO}/gpg | sudo apt-key add -
	sudo add-apt-repository "deb [arch=amd64] ${DOCKER-REPO} $$(lsb_release -cs) stable"

	# Install containerd
	sudo apt update
	sudo apt install -y containerd.io

	# Configure containerd and start service
	sudo mkdir -p /etc/containerd
	sudo su -
	containerd config default  /etc/containerd/config.toml

	# restart containerd
	sudo systemctl restart containerd
	sudo systemctl enable containerd

create-and-validate: install-kubeadmin configure-kube configure-network validate

validate: confirm-master-ready validate-cluster deploy-dashboard create-context create-load-balancer

install-kubeadmin:
	lsmod | grep br_netfilter
	sudo systemctl enable kubelet
	sudo kubeadm config images pull

	#set_cluster_dns: in hosts
	#sudo nano /etc/hosts
	sudo kubeadm init --control-plane-endpoint=${CLUSTER-DNS}
configure-kube:
	mkdir -p $$HOME/.kube
	sudo cp -i /etc/kubernetes/admin.conf $$HOME/.kube/config
	sudo chown $$(id -u):$$(id -g) $$HOME/.kube/config

configure-network:
	kubectl apply -f https://docs.projectcalico.org/manifests/calico.yaml

confirm-master-ready:
	kubectl get nodes -o wide

#Join worker to master
#kubeadm join osfx-cluster.osfx.cloud:6443 --token 2e9khr.oimebg6g9xfjowue  --discovery-token-ca-cert-hash sha256:3414dd8511b49faa1a1d941595d6fd154275b26fb028e52d2a5cdc95fce25326
#kubeadm join 192.168.100.6:6443 --token 8e0e9y.u0529mlepsup5tpu --discovery-token-ca-cert-hash sha256:dd2685a2bc9bcc63fb6e24d827a0b5d0b83745928829d60cd542f782bccb6cdd
validate-cluster:
	kubectl apply -f https://k8s.io/examples/pods/commands.yaml

deploy-dashboard:
	kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/master/aio/deploy/recommended.yaml
	wget https://raw.githubusercontent.com/kubernetes/dashboard/master/aio/deploy/recommended.yaml
	mv recommended.yaml kubernetes-dashboard-deployment.yml
	#modify to fit needs
	#vim kubernetes-dashboard-deployment.yml
	kubectl apply -f kubernetes-dashboard-deployment.yml
	kubectl get deployments -n kubernetes-dashboard 
	kubectl get pods -n kubernetes-dashboard

create-context:
	kubectl apply -f osfx-context.yaml
	kubectl config use-context kubernetes-admin@kubernetes
	kubectl config set-context osfx --namespace=osfx --cluster=kubernetes --user=kubernetes-admin

create-load-balancer: update-kube-proxy install-metalb configure-balancer deploy-ingress

update-kube-proxy:
	kubectl get configmap kube-proxy -n kube-system -o yaml | sed -e "s/strictARP: false/strictARP: true/" | kubectl apply -f - -n kube-system
install-metalb:
	kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.9.5/manifests/namespace.yaml
	kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.9.5/manifests/metallb.yaml
	# On first install only
	kubectl create secret generic -n metallb-system memberlist --from-literal=secretkey="$$(openssl rand -base64 128)"

configure-balancer:
	kubectl apply -f metallb-config.yaml

deploy-ingress:
	#kubectl create namespace fluxcd
	#helm upgrade -i flux fluxcd/flux --wait --namespace fluxcd --set git.url=git@github.com:ocularminds/helmflux
	#kubectl apply -f osfx-ingress.yaml
	helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
	helm repo update
	helm install helm3 ingress-nginx/ingress-nginx	