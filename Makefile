FLAGS = --context
CONTEXT = osfx
FILE = -f
deploy-all: deploy-mq deploy-hsm deploy-db deploy-bank

deploy-bank: deploy-finacle deploy-flexcube

deploy-db: 
	kubectl ${FLAGS} ${CONTEXT} apply ${FILE} osfx-db.yaml

deploy-hsm: 
	kubectl ${FLAGS} ${CONTEXT} apply ${FILE} osfx-hsm.yaml

deploy-mq: 
	kubectl ${FLAGS} ${CONTEXT} apply ${FILE} osfx-mq.yaml

deploy-finacle: finacle-secret finacle-deploy finacle-service

deploy-flexcube: finacle-secret finacle-deploy finacle-service

finacle-secret: 
	kubectl ${FLAGS} ${CONTEXT} apply ${FILE} osfx-finacle-secret.yaml
finacle-deploy:
	kubectl ${FLAGS} ${CONTEXT} apply ${FILE} osfx-finacle-deploy.yaml
finacle-service:	
	kubectl ${FLAGS} ${CONTEXT} apply ${FILE} osfx-finacle-service.yaml

flexcube-secret: 
	kubectl ${FLAGS} ${CONTEXT} apply ${FILE} osfx-flexcube-secret.yaml
flexcube-deploy:
	kubectl ${FLAGS} ${CONTEXT} apply ${FILE} osfx-flexcube-deploy.yaml
flexcube-service:	
	kubectl ${FLAGS} ${CONTEXT} apply ${FILE} osfx-flexcube-service.yaml