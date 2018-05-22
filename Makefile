# Make sure this insecure registry is added to local Docker daemon
INSECURE_LOCAL_REGISTRY=docker.for.mac.localhost:5000

.PHONY: setup_development_registry
setup_development_registry:
	kubectl config use-context docker-for-desktop
	helm install stable/docker-registry \
		--namespace default \
		--name docker-registry \
		--set service.type=LoadBalancer \
		--set persistence.enabled=true

.PHONY: setup_development
setup_development:
	kubectl config use-context docker-for-desktop
	helm init --upgrade --service-account default

.PHONY: build_development_nginx
build_development_nginx:
	docker build \
		--build-arg CONF=development.conf \
		-t $(INSECURE_LOCAL_REGISTRY)/template/nginx-deployment:latest \
		-f src/nginx/Dockerfile src/nginx

	docker push $(INSECURE_LOCAL_REGISTRY)/template/nginx-deployment:latest

.PHONY: build_development_web
build_development_web:
	docker build \
		-t $(INSECURE_LOCAL_REGISTRY)/template/web-deployment:latest \
		-f src/web/Dockerfile src/web

	docker push $(INSECURE_LOCAL_REGISTRY)/template/web-deployment:latest

.PHONY: install_development
install_development:
	kubectl config use-context docker-for-desktop
	kubectl create ns template
	kubectl config set-context docker-for-desktop --namespace=template
	helm install --name template ./chart

.PHONY: upgrade_development
upgrade_development:
	helm upgrade template ./chart

.PHONY: update_helm_repo
update_helm_repo:
	helm repo update

.PHONY: install_dry_run
install_dry_run:
	kubectl config use-context docker-for-desktop
	helm install --name template --dry-run --debug ./chart

.PHONY: delete_development
delete_development:
	helm delete template --purge
	kubectl delete ns template