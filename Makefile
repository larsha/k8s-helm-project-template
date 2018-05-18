# Make sure this insecure registry is added to local Docker daemon
INSECURE_LOCAL_REGISTRY=docker.for.mac.localhost:5000

.PHONY: setup_development
setup_development:
	kubectl create ns egm
	kubens egm
	helm init --upgrade --service-account default
	helm install stable/docker-registry \
		--namespace default \
		--name docker-registry \
		--set service.type=LoadBalancer \
		--set persistence.enabled=true

.PHONY: deploy_development
deploy_development:
	kubectx docker-for-desktop
	kubens egm

	# Nginx
	docker build \
		-t $(INSECURE_LOCAL_REGISTRY)/egm/nginx-deployment:latest \
		-f src/nginx/Dockerfile src/nginx

	docker push $(INSECURE_LOCAL_REGISTRY)/egm/nginx-deployment:latest

	# Web
	docker build \
		-t $(INSECURE_LOCAL_REGISTRY)/egm/web-deployment:latest \
		-f src/web/Dockerfile src/web

	docker push $(INSECURE_LOCAL_REGISTRY)/egm/web-deployment:latest

.PHONY: update_helm_repo
update_helm_repo:
	helm repo update

.PHONY: install_dry_run
install_dry_run:
	helm install --dry-run --debug ./chart