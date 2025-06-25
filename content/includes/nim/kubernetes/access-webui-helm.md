---
docs: DOCS-1323
---

You can access the NGINX Instance Manager web interface using the external IP address for the API Gateway.

1. To look up the external IP address for the API Gateway, run the following command:

   ```bash
   kubectl -n nim get svc apigw
   ```

   This `kubectl` command shows details for the `apigw` service in the `nim` namespace. You’ll see the service type, port, cluster IP, and external IP addresses.

   The default service type is `ClusterIP` and the output looks similar to the following example:

   ```text
   NAME    TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)   AGE
   apigw   ClusterIP   10.108.57.167   <none>        443/TCP   32s
   ```

   Using the `CLUSTER-IP` value, go to `https://<CLUSTER-IP>:443/ui`.

   For example, `https://10.108.57.167/ui`.

   This IP address might not be reachable, depending on how the Kubernetes cluster networking was configured. If so, the `apigw` service type can be changed to a more suitable option, such as `LoadBalancer`, by changing the [Configurable Helm Setting]({{< ref "/nim/deploy/kubernetes/helm-config-settings.md" >}}) value for `apigw.service.type`.
