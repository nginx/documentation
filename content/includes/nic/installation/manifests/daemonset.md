---
nd-docs: DOCS-1465
nd-files:
- content/nic/install/manifests.md
- content/nic/integrations/app-protect-dos/installation.md
- content/nic/integrations/app-protect-waf-v5/installation.md
- content/nic/integrations/app-protect-waf/installation.md
---

For additional context on managing containers using Kubernetes DaemonSets, refer to the official Kubernetes [DaemonSets](https://kubernetes.io/docs/concepts/workloads/controllers/daemonset/) documentation.

When you deploy NGINX Ingress Controller as a DaemonSet, Kubernetes creates an Ingress Controller pod on every node in the cluster.

- For NGINX, run:

    ```shell
    kubectl apply -f deployments/daemon-set/nginx-ingress.yaml
    ```

- For NGINX Plus, run:

    ```shell
    kubectl apply -f deployments/daemon-set/nginx-plus-ingress.yaml
    ```

    Update the `nginx-plus-ingress.yaml` file to include your chosen image from the F5 Container registry or your custom container image.
