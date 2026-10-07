---
f5-product: NGINX One Console
f5-files:
- content/nginx-one-console/k8s/add-ngf-helm.md
- content/nginx-one-console/k8s/add-ngf-manifests.md
---

If you encounter issues connecting your instances to NGINX One Console, try the following commands:

Check the NGINX Agent version:

```shell
kubectl exec -it -n <NAMESPACE> <NGINX_POD_NAME> -- nginx-agent -v
```

Replace `<NAMESPACE>` with the Kubernetes namespace where NGINX is deployed and `<NGINX_POD_NAME>` with the name of your NGINX Pod.

Check the NGINX Agent configuration:

```shell
kubectl exec -it -n <NAMESPACE> <NGINX_POD_NAME> -- cat /etc/nginx-agent/nginx-agent.conf
```

Check NGINX Agent logs:

```shell
kubectl exec -it -n <NAMESPACE> <NGINX_POD_NAME> -- nginx-agent
```
