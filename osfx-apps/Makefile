FLAGS = --context
CONTEXT = osfx
FILE = -f
deploy-all: deploy-mq deploy-hsm deploy-db deploy-bank deploy-apps

deploy-bank: deploy-finacle deploy-flexcube

deploy-db: 
	kubectl ${FLAGS} ${CONTEXT} apply ${FILE} osfx-mysql.yaml

deploy-hsm: 
	kubectl ${FLAGS} ${CONTEXT} apply ${FILE} osfx-hsm.yaml

deploy-mq: 
	kubectl ${FLAGS} ${CONTEXT} apply ${FILE} osfx-mq.yaml

deploy-finacle: flexcube-secret finacle-deploy finacle-service

deploy-flexcube: flexcube-secret finacle-deploy flexcube-service

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

deploy-apps: deploy-auth deploy-user deploy-data deploy-card deploy-tmc deploy-auto deploy-ui

deploy-auth: auth-secret auth-deploy

auth-secret:
	kubectl ${FLAGS} ${CONTEXT} apply ${FILE} osfx-auth-secret.yaml
auth-deploy:
	kubectl ${FLAGS} ${CONTEXT} apply ${FILE} osfx-auth-deploy.yaml

deploy-user: user-secret user-deploy

user-secret:
	kubectl ${FLAGS} ${CONTEXT} apply ${FILE} osfx-user-secret.yaml
user-deploy:
	kubectl ${FLAGS} ${CONTEXT} apply ${FILE} osfx-user-deploy.yaml

deploy-data: data-secret data-deploy

data-secret:
	kubectl ${FLAGS} ${CONTEXT} apply ${FILE} osfx-data-secret.yaml
data-deploy:
	kubectl ${FLAGS} ${CONTEXT} apply ${FILE} osfx-data-deploy.yaml

deploy-card: card-secret card-deploy

card-secret:
	kubectl ${FLAGS} ${CONTEXT} apply ${FILE} osfx-card-secret.yaml
card-deploy:
	kubectl ${FLAGS} ${CONTEXT} apply ${FILE} osfx-card-deploy.yaml

deploy-auto: auto-secret auto-deploy

auto-secret:
	kubectl ${FLAGS} ${CONTEXT} apply ${FILE} osfx-tmc-secret.yaml
auto-deploy:
	kubectl ${FLAGS} ${CONTEXT} apply ${FILE} osfx-tmc-deploy.yaml

deploy-tmc: tmc-secret tmc-deploy

tmc-secret:
	kubectl ${FLAGS} ${CONTEXT} apply ${FILE} osfx-tmc-secret.yaml
tmc-deploy:
	kubectl ${FLAGS} ${CONTEXT} apply ${FILE} osfx-tmc-deploy.yaml

deploy-msg: msg-secret msg-deploy msg-service

msg-secret:
	kubectl ${FLAGS} ${CONTEXT} apply ${FILE} osfx-msg-secret.yaml
msg-deploy:
	kubectl ${FLAGS} ${CONTEXT} apply ${FILE} osfx-msg-deploy.yaml
msg-service:
	kubectl ${FLAGS} ${CONTEXT} apply ${FILE} osfx-msg-service.yaml

deploy-ui: 
	kubectl ${FLAGS} ${CONTEXT} apply ${FILE} osfx-ui-deploy.yaml
