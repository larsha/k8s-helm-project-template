# k8s-helm-project-template

This repo aims to provide a starting point for creating a project utilizing Kubernetes with multiple environments including local/development.
Comes packed with an simple example PHP app.

### Prerequisites

- Kubernetes (Docker for Mac (edge) / Minikube)
- Helm [https://helm.sh/](https://helm.sh/)
- `kubectl` [https://kubernetes.io/docs/tasks/tools/install-kubectl/](https://kubernetes.io/docs/tasks/tools/install-kubectl/)

### Good to have
For fast switching of k8s clusters in terminal

- `kubectx` [https://github.com/ahmetb/kubectx](https://github.com/ahmetb/kubectx)

### Environments
You can have just one environment or multiple, it's up to you.

- Cluster 0 - Local/Development
- Cluster 1 - Staging
- Cluster 2 - Production

### Guides / Useful links

[https://kubernetes.io/docs/concepts/cluster-administration/manage-deployment/#organizing-resource-configurations](https://kubernetes.io/docs/concepts/cluster-administration/manage-deployment/#organizing-resource-configurations)