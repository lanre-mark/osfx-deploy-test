FLAGS = -n
CONTEXT = osfx
FILE = -f
ACTION = apply
SECRET-YAML = -o yaml --dry-run=client > 
SECRET-CMD=create secret generic -n osfx
FIELD=--from-literal

deploy-all: deploy-mq deploy-hsm deploy-db deploy-bank deploy-apps
	kubectl  ${FLAGS} ${CONTEXT} ${ACTION} ${FILE} osfx-domains.yaml

deploy-bank: deploy-finacle deploy-flexcube

deploy-db: 
	kubectl ${FLAGS} ${CONTEXT} ${ACTION} ${FILE} osfx-mysql.yaml

deploy-hsm: 
	kubectl ${FLAGS} ${CONTEXT} ${ACTION} ${FILE} osfx-hsm.yaml

deploy-mq: 
	kubectl ${FLAGS} ${CONTEXT} ${ACTION} ${FILE} osfx-mq.yaml

deploy-finacle: flexcube-secret finacle-deploy finacle-service

deploy-flexcube: flexcube-secret flexcube-deploy flexcube-service

finacle-secret: 
	kubectl ${FLAGS} ${CONTEXT} ${ACTION} ${FILE} osfx-finacle-secret.yaml
finacle-deploy:
	kubectl ${FLAGS} ${CONTEXT} ${ACTION} ${FILE} osfx-finacle-deploy.yaml
finacle-service:	
	kubectl ${FLAGS} ${CONTEXT} ${ACTION} ${FILE} osfx-finacle-service.yaml

flexcube-secret: 
	kubectl ${FLAGS} ${CONTEXT} ${ACTION} ${FILE} osfx-flexcube-secret.yaml
flexcube-deploy:
	kubectl ${FLAGS} ${CONTEXT} ${ACTION} ${FILE} osfx-flexcube-deploy.yaml
flexcube-service:	
	kubectl ${FLAGS} ${CONTEXT} ${ACTION} ${FILE} osfx-flexcube-service.yaml

deploy-apps: deploy-auth deploy-user deploy-data deploy-card deploy-tmc deploy-auto deploy-ui

deploy-auth: auth-secret auth-deploy

auth-secret:
	kubectl ${FLAGS} ${CONTEXT} ${ACTION} ${FILE} osfx-auth-secret.yaml
auth-deploy:
	kubectl ${FLAGS} ${CONTEXT} apply ${FILE} osfx-auth-deploy.yaml

deploy-user: user-secret user-deploy

user-secret:
	kubectl ${FLAGS} ${CONTEXT} ${ACTION} ${FILE} osfx-user-secret.yaml
user-deploy:
	kubectl ${FLAGS} ${CONTEXT} ${ACTION} ${FILE} osfx-user-deploy.yaml

deploy-data: data-secret data-deploy

data-secret:
	kubectl ${FLAGS} ${CONTEXT} ${ACTION} ${FILE} osfx-data-secret.yaml
data-deploy:
	kubectl ${FLAGS} ${CONTEXT} ${ACTION} ${FILE} osfx-data-deploy.yaml

deploy-card: card-secret card-deploy

card-secret:
	kubectl ${FLAGS} ${CONTEXT} ${ACTION} ${FILE} osfx-card-secret.yaml
card-deploy:
	kubectl ${FLAGS} ${CONTEXT} ${ACTION} ${FILE} osfx-card-deploy.yaml

deploy-auto: auto-secret auto-deploy

auto-secret:
	kubectl ${FLAGS} ${CONTEXT} ${ACTION} ${FILE} osfx-auto-secret.yaml
auto-deploy:
	kubectl ${FLAGS} ${CONTEXT} ${ACTION} ${FILE} osfx-auto-deploy.yaml

deploy-tmc: tmc-secret tmc-deploy

tmc-secret:
	kubectl ${FLAGS} ${CONTEXT} ${ACTION} ${FILE} osfx-tmc-secret.yaml
tmc-deploy:
	kubectl ${FLAGS} ${CONTEXT} ${ACTION} ${FILE} osfx-tmc-deploy.yaml

deploy-msg: msg-secret msg-deploy msg-service

msg-secret:
	kubectl ${FLAGS} ${CONTEXT} ${ACTION} ${FILE} osfx-msg-secret.yaml
msg-deploy:
	kubectl ${FLAGS} ${CONTEXT} ${ACTION} ${FILE} osfx-msg-deploy.yaml
msg-service:
	kubectl ${FLAGS} ${CONTEXT} ${ACTION} ${FILE} osfx-msg-service.yaml

deploy-ui: 
	kubectl ${FLAGS} ${CONTEXT} ${ACTION} ${FILE} osfx-ui-deploy.yaml

create-secrets: create-user-secret

create-user-secret:
	kubectl ${SECRET-CMD} osfx-any-secret ${FIELD}=secretkey="$(openssl rand -base64 128)" ${FIELD}=host-url="http://nonese.ng" ${SECRET-YAML} osfx-any-secret.yaml

create-auth-secret:
	kubectl ${SECRET-CMD} osfx-auth-secrete ${FIELD}=username="osfx" ${FIELD}=password="osfx" ${FIELD}=database="" ${FIELD}=mqaddress="" ${FIELD}=dbconurl="" ${FIELD}=tokenkey="" ${SECRET-YAML} osfx-auth-secret.yaml
