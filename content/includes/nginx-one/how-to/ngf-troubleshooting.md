---
nd-docs: "DOCS-000"
files:
- content/nginx-one/k8s/add-ngf-manifests.md
- content/nginx-one/k8s/add-ngf-helm.md
---

If you encounter issues connecting your instances to NGINX One Console, try the following commands:

Check the NGINX Agent version:

```shell
kubectl exec -it -n <namespace> <nginx_pod_name> -- nginx-agent -v
```

Check the NGINX Agent configuration:

```shell
kubectl exec -it -n <namespace> <nginx_pod_name> -- cat /etc/nginx-agent/nginx-agent.conf
```

Check NGINX Agent logs:

```shell
kubectl exec -it -n <namespace> <nginx_pod_name> -- nginx-agent
```
