FLAGS = --context
CONTEXT = osfx
FILE = -f
deploy-all: deploy-mq deploy-hsm deploy-finacle deploy-flexcube

deploy-hsm: 
	kubectl ${FLAGS} ${CONTEXT} apply ${FILE} osfx-hsm.yaml

deploy-mq: 
	kubectl ${FLAGS} ${CONTEXT} apply ${FILE} osfx-mq.yaml

deploy-finacle: finacle-secret finacle-deploy finacle-service

deploy-flexcube: finacle-secret finacle-deploy finacle-service

finacle-secret: 
	kubectl ${FLAGS} ${CONTEXT} osfx-finacle-secret.yaml
finacle-deploy:
	kubectl ${FLAGS} ${CONTEXT} osfx-finacle-deploy.yaml
finacle-service:	
	kubectl ${FLAGS} ${CONTEXT} osfx-finacle-service.yaml

flexcube-secret: 
	kubectl ${FLAGS} ${CONTEXT} osfx-flexcube-secret.yaml
flexcube-deploy:
	kubectl ${FLAGS} ${CONTEXT} osfx-flexcube-deploy.yaml
flexcube-service:	
	kubectl ${FLAGS} ${CONTEXT} osfx-flexcube-service.yaml