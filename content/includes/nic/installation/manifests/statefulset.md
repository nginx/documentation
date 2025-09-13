---
nd-docs: DOCS-000
---

For additional context on managing containers using Kubernetes StatefulSets, refer to the official Kubernetes [StatefulSets](https://kubernetes.io/docs/concepts/workloads/controllers/statefulset/) documentation.

When you deploy NGINX Ingress Controller as a StatefulSet, Kubernetes creates pods with stable network identities and persistent storage.

- For NGINX, run:

    ```shell
    kubectl apply -f deployments/stateful-set/nginx-ingress.yaml
    ```

- For NGINX Plus, run:

    ```shell
    kubectl apply -f deployments/stateful-set/nginx-plus-ingress.yaml
    ```

    Update the `nginx-plus-ingress.yaml` file to include your chosen image from the F5 Container registry or your custom container image.

{{< call-out "note" >}}
StatefulSets include persistent volume claims for nginx cache storage via `volumeClaimTemplates`. You may need to configure a StorageClass in your cluster or modify the volumeClaimTemplates section in the manifest to match your storage requirements. Other volumes (like those needed for App Protect modules) are configured in the regular `volumes` section, not in volumeClaimTemplates. 
{{< /call-out >}}
