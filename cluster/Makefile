step1:
sudo apt update
sudo apt -y upgrade && sudo systemctl reboot

step2:
    sudo apt update
    sudo apt -y install curl apt-transport-https
    curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
    echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list
    sudo apt update
    sudo apt -y install vim git curl wget kubelet kubeadm kubectl
    sudo apt-mark hold kubelet kubeadm kubectl

step3_disable_swap:
    sudo sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab
    sudo swapoff -a

configure_ctl:
    sudo modprobe overlay
    sudo modprobe br_netfilter

    sudo tee /etc/sysctl.d/kubernetes.conf<<EOF
    net.bridge.bridge-nf-call-ip6tables = 1
    net.bridge.bridge-nf-call-iptables = 1
    net.ipv4.ip_forward = 1
    EOF

    sudo sysctl --system

setp4_install_runtime: install-docker install-containerd
    # Add repo and Install packages
sudo apt update
sudo apt install -y curl gnupg2 software-properties-common apt-transport-https ca-certificates
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
sudo apt update
sudo apt install -y containerd.io docker-ce docker-ce-cli

# Create required directories
sudo mkdir -p /etc/systemd/system/docker.service.d

# Create daemon json config file
sudo tee /etc/docker/daemon.json <<EOF
{
  "exec-opts": ["native.cgroupdriver=systemd"],
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "100m"
  },
  "storage-driver": "overlay2"
}
EOF

# Start and enable Services
sudo systemctl daemon-reload 
sudo systemctl restart docker
sudo systemctl enable docker
Installing CRI-O:

# Ensure you load modules
sudo modprobe overlay
sudo modprobe br_netfilter

# Set up required sysctl params
sudo tee /etc/sysctl.d/kubernetes.conf<<EOF
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
net.ipv4.ip_forward = 1
EOF

# Reload sysctl
sudo sysctl --system

# Add repo
. /etc/os-release
sudo sh -c "echo 'deb http://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable/x${NAME}_${VERSION_ID}/ /' > /etc/apt/sources.list.d/devel:kubic:libcontainers:stable.list"
wget -nv https://download.opensuse.org/repositories/devel:kubic:libcontainers:stable/x${NAME}_${VERSION_ID}/Release.key -O- | sudo apt-key add -
sudo apt update

# Install CRI-O
sudo apt install cri-o-1.17

# Start and enable Service
sudo systemctl daemon-reload
sudo systemctl start crio
sudo systemctl enable crio
Installing Containerd:

# Configure persistent loading of modules
sudo tee /etc/modules-load.d/containerd.conf <<EOF
overlay
br_netfilter
EOF

# Load at runtime
sudo modprobe overlay
sudo modprobe br_netfilter

# Ensure sysctl params are set
sudo tee /etc/sysctl.d/kubernetes.conf<<EOF
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
net.ipv4.ip_forward = 1
EOF

# Reload configs
sudo sysctl --system

# Install required packages
sudo apt install -y curl gnupg2 software-properties-common apt-transport-https ca-certificates


# Add Docker repo
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"

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

step5_init_kubeadmin:
lsmod | grep br_netfilter
sudo systemctl enable kubelet
sudo kubeadm config images pull

#set_cluster_dns: in hosts
#sudo nano /etc/hosts
#172.18.0.1 k8s-cluster.osfx.cloud

sudo kubeadm init --pod-network-cidr=192.168.0.0/16  --control-plane-endpoint=osfx-cluster.osfx.cloud

step6_configure_kube:
	mkdir -p $HOME/.kube
	sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
	sudo chown $(id -u):$(id -g) $HOME/.kube/config

step7_install_network_plugin:
	kubectl apply -f https://docs.projectcalico.org/manifests/calico.yaml

step8_confirm_master_node_ready:
	kubectl get nodes -o wide

#Join worker to master
kubeadm join osfx-cluster.osfx.cloud:6443 --token 2e9khr.oimebg6g9xfjowue  --discovery-token-ca-cert-hash sha256:3414dd8511b49faa1a1d941595d6fd154275b26fb028e52d2a5cdc95fce25326

step9_validate_cluster:
	kubectl apply -f https://k8s.io/examples/pods/commands.yaml

step10_deploy_dashboard:
	kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/master/aio/deploy/recommended.yaml
	wget https://raw.githubusercontent.com/kubernetes/dashboard/master/aio/deploy/recommended.yaml
    mv recommended.yaml kubernetes-dashboard-deployment.yml
	#modify to fit needs
	#vim kubernetes-dashboard-deployment.yml
	kubectl apply -f kubernetes-dashboard-deployment.yml
	kubectl get deployments -n kubernetes-dashboard 
    kubectl get pods -n kubernetes-dashboard