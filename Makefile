.PHONY: setup_development deploy_web_development deploy_php_web_development setup_staging setup_production update_helm_repo

INSECURE_LOCAL_REGISTRY=docker.for.mac.localhost:5000

setup_development:
	kubectl create -f k8s/namespaces/development.yaml -f k8s/development --recursive
	helm init --upgrade --service-account default
	helm install stable/docker-registry --name docker-registry --set service.type=LoadBalancer

# Before deploying to development cluster, make sure docker can push to insecure local repository
deploy_web_development:
	kubectx docker-for-desktop
	kubens egm-development
	docker build \
      -t $(INSECURE_LOCAL_REGISTRY)/egm-development/web-deployment:latest \
      -f src/web/Dockerfile src/web

	docker push $(INSECURE_LOCAL_REGISTRY)/egm-development/web-deployment:latest
	kubectl set image deployment/web-deployment web=$(INSECURE_LOCAL_REGISTRY)/egm-development/web-deployment:latest

deploy_php_development:
	kubectx docker-for-desktop
	kubens egm-development

	# Nginx
	docker build \
      -t $(INSECURE_LOCAL_REGISTRY)/egm-development/php-nginx-deployment:latest \
      -f src/php/nginx/Dockerfile src/php/nginx

	docker push $(INSECURE_LOCAL_REGISTRY)/egm-development/php-nginx-deployment:latest
	kubectl set image deployment/php-nginx-deployment php-nginx=$(INSECURE_LOCAL_REGISTRY)/egm-development/php-nginx-deployment:latest

	# Web
	docker build \
	  -t $(INSECURE_LOCAL_REGISTRY)/egm-development/php-web-deployment:latest \
	  -f src/php/web/Dockerfile src/php/web

	docker push $(INSECURE_LOCAL_REGISTRY)/egm-development/php-web-deployment:latest
	kubectl set image deployment/php-web-deployment php-web=$(INSECURE_LOCAL_REGISTRY)/egm-development/php-web-deployment:latest

#setup_staging:
#	kubectx egm-staging
#	kubens egm-staging
#	helm init --upgrade --service-account default
#	kubectl create -f k8s/namespaces/staging.yaml -f k8s/staging --recursive
#
#setup_production:
#	kubectx egm-production
#	kubens egm-production
#	helm init --upgrade --service-account default
#	kubectl create -f k8s/namespaces/production.yaml -f k8s/production --recursive

update_helm_repo:
	helm repo update