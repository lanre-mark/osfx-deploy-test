CLUSTER-PERMISSIONS=--clusterrole=cluster-admin  --user=admin  --user=kubelet
CLUSTER-GROUP= --group=system:serviceaccounts
KUBE-CONTEXT= -n kube-system
DNS-VOLUME-CONFIG= -p "{\"spec\": {\"template\": {\"spec\": {\"volumes\": [{\"configMap\": {\"items\": [{\"key\": \"Corefile\",\"path\": \"Corefile\"},{\"key\": \"osfx.db\",\"path\": \"osfx.db\"}],\"name\": \"coredns\"},\"name\": \"config-volume\"}]}}}}}"
install-multipass:
	snap install multipass

install-tools: 
	sudo apt install make

create-cluster: install-tools spin-kubernetes
	
add-node: 
	microk8s add-node
add-permission:
	kubectl create clusterrolebinding permissive-binding ${CLUSTER-PERMISSIONS} ${CLUSTER-GROUP}

nameserver-ip:
	grep "nameserver" /run/systemd/resolve/resolv.conf | awk '{print $$2}'
	
configure-cluster: 
	echo "osfx - configuring cluster..."
	configure-network configure-state

configure-network:
	echo "osfx - configuring cluster infrastructure ..."
	microk8s enable istio metallb storage
	kubectl apply -f ../yaml/0_osfx_mandatory.yaml 
	microk8s enable dns ingress dashboard

configure-state:
	echo "osfx - configuring state for high performance..."
	mkdir -p /home/ubuntu/osfx/run /home/ubuntu/osfx/lib
	cat EOF /var/snap/microk8s/current/args/containerd <<
	--config ${SNAP_DATA}/args/containerd.toml
	--root /home/ubuntu/osfx/lib/containerd
	--state /home/ubuntu/osfx/run/containerd
	--address ${SNAP_COMMON}/run/containerd.sock
	EOF
	echo "osfx - configuring state completed."
	sudo microk8s stop
	sudo microk8s start


patch-dns:
	kubectl ${KUBE-CONTEXT} patch deployment coredns ${DNS-VOLUME-CONFIG}
	echo "--resolv-conf=/run/systemd/resolve/resolv.conf" >> /var/snap/microk8s/current/args/kubelet
	sudo service snap.microk8s.daemon-kubelet restart
	kubectl ${KUBE-CONTEXT} apply -f kube-dns.yaml  
	
configure-dns:
	sudo snap install jq
	kubectl apply -f osfx-dns.yaml
	restart-dns
restart-dns:
	kubectl get pods ${KUBE-CONTEXT} | grep dns | awk '{print $$1}' | xargs kubectl delete pod ${KUBE-CONTEXT}

create-nodes: create-main create-node create-work
create-main: install-multipass
	multipass launch -m 16G -n osfx-main -d 100G -c 2
	multipass shell osfx-main

create-node:
	multipass launch -m 8Gb -n osfx-node -d 80G
	multipass shell osfx-node

create-work:
	multipass launch -m 8G -n osfx-work
	multipass shell osfx-work

create-jobs:
	multipass launch -m 8G -c 2 -n osfx-jobs
	multipass shell osfx-jobs

spin-kubernetes:
	sudo snap install microk8s --classic --channel=1.19/stable
	sudo snap alias microk8s.kubectl kubectl
	sudo usermod -a -G microk8s ubuntu
	sudo chown -f -R ubuntu ~/.kube
	exit
cluster-ip:
	kubectl get service --namespace kube-system kube-dns -o jsonpath="{.spec.clusterIP}"
clean-pods:  clean-osfx-pods clean-kube-pods 
clean-osfx-pods:
	kubectl get pod -n osfx | grep Evicted | awk '{print $$1}' | xargs kubectl delete pod -n osfx
	kubectl get pod -n osfx | grep CrashLoopBackOff | awk '{print $$1}' | xargs kubectl delete pod -n osfx
	kubectl get pod -n osfx | grep ImagePullBackBackOff | awk '{print $$1}' | xargs kubectl delete pod -n osfx
	kubectl get pod -n osfx | grep Terminating | awk '{print $$1}' | xargs kubectl delete pod -n osfx
	
clean-kube-pods:
	kubectl get pod ${KUBE-CONTEXT} | grep Evicted | awk '{print $$1}' | xargs kubectl delete pod ${KUBE-CONTEXT}
	kubectl get pod ${KUBE-CONTEXT} | grep CrashLoopBackOff | awk '{print $$1}' | xargs kubectl delete pod ${KUBE-CONTEXT}
	kubectl get pod ${KUBE-CONTEXT} | grep ImagePullBackBackOff | awk '{print $$1}' | xargs kubectl delete pod ${KUBE-CONTEXT}
	kubectl get pod ${KUBE-CONTEXT} | grep Terminating | awk '{print $$1}' | xargs kubectl delete pod ${KUBE-CONTEXT}
