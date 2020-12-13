FLAGS = --context
CONTEXT = default
deploy-all: deploy-mq deploy-hsm deploy-finacle deploy-flexcube
deploy-hsm: 
	kubectl ${FLAGS} ${context} apply -f osfx-hsm.yaml

deploy-mq: 
	kubectl ${FLAGS} ${context} apply -f osfx-mq.yaml

deploy-finacle: finacle-secret finacle-deploy finacle-service

deploy-flexcube: finacle-secret finacle-deploy finacle-service

finacle-secret: 
	kubectl ${FLAGS} ${context} apply -f osfx-finacle-secret.yaml
finacle-deploy:
	kubectl ${FLAGS} ${context} apply -f osfx-finacle-deploy.yaml
finacle-service:	
	kubectl ${FLAGS} default apply -f osfx-finacle-service.yaml

flexcube-secret: 
	kubectl ${FLAGS} ${context} apply -f osfx-flexcube-secret.yaml
flexcube-deploy:
	kubectl ${FLAGS} ${context} apply -f osfx-flexcube-deploy.yaml
flexcube-service:	
	kubectl ${FLAGS} default apply -f osfx-flexcube-service.yaml