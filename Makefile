FLAGS = --context
CONTEXT = default
deploy-finacle: finacle-secret finacle-deploy finacle-service

finacle-secret: osfx-finacle-secret.yaml
	kubectl ${FLAGS} ${context} apply -f osfx-finacle-secret.yaml
finacle-deploy:
	kubectl ${FLAGS} ${context} apply -f osfx-finacle-deploy.yaml
finacle-service:	
	kubectl ${FLAGS} default apply -f osfx-finacle-service.yaml