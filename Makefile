INSECURE_LOCAL_REGISTRY=docker.for.mac.localhost:5000

.PHONY: setup_development
setup_development:
	kubectl create ns egm-development
	kubens egm-development
	helm init --upgrade --service-account default
	helm install stable/docker-registry \
		--namespace default \
		--name docker-registry \
		--set service.type=LoadBalancer \
		--set persistence.enabled=true

.PHONY: deploy_php_development
deploy_php_development:
	kubectx docker-for-desktop
	kubens egm-development

	# Nginx
	docker build \
      -t $(INSECURE_LOCAL_REGISTRY)/egm-development/nginx-deployment:latest \
      -f src/nginx/Dockerfile src/nginx

	docker push $(INSECURE_LOCAL_REGISTRY)/egm-development/nginx-deployment:latest

	# Web
	docker build \
	  -t $(INSECURE_LOCAL_REGISTRY)/egm-development/web-deployment:latest \
	  -f src/web/Dockerfile src/web

	docker push $(INSECURE_LOCAL_REGISTRY)/egm-development/web-deployment:latest

.PHONY: update_helm_repo
update_helm_repo:
	helm repo update

.PHONY: install_dry_run
install_dry_run:
	helm install --dry-run --debug ./chart