---
docs:
---

Query the Instance Manager REST API to get the list of NGINX Ingress Controller instances and nodes in the cluster. Replace `<NMS_FQDN>` with the fully-qualified domain name for your NGINX Management Suite host.

```sh
curl -X GET --url "https://<NMS_FQDN>/api/platform/v1/k8s-usage"
```

You can then send this list to your F5 representative.

{{<call-out tip "Tip: automate reporting with your JWT license">}}To enable automatic reporting, [apply your JSON Web Token (JWT) license to NGINX Management Suite]({{< relref "nms/installation/add-license.md#apply-jwt-license" >}}). If needed, you can download this file from [MyF5](https://account.f5.com/myf5).{{</call-out>}}

