---

---

You can access the NGINX Management Suite web interface using the external IP address for the API Gateway.

1. To look up the external IP address for the API Gateway, run the following command:

   ```bash
   kubectl -n nms get svc apigw
   ```

   This `kubectl` command retrieves the service named `apigw` from the namespace `nms`. It outputs the details of the service, such as its type, port, cluster and external IP addresses.

   The output looks similar to the following example. Note the value in the `EXTERNAL-IP` column.

   ```text
   NAME    TYPE           CLUSTER-IP      EXTERNAL-IP   PORT(S)         AGE
   apigw   LoadBalancer   10.100.153.15   localhost     443:30414/TCP   2m1s
   ```

1. Using the value from the previous step, go to `https://<apigw-EXTERNAL-IP>:443/ui`.

   For example, `https://localhost:443/ui`.
