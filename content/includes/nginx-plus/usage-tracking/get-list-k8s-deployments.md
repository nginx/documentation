---
docs:
---

Query the Kubernetes Usage API to get the list of your NGINX Kubernetes clusters and relevant deployment information, including node and pod counts. Replace `<NMS_FQDN>` with the fully-qualified domain name for your NGINX Management Suite host.

```sh
curl -X GET --url "https://<NMS_FQDN>/api/platform/v1/k8s-usage"
```

You can then send this list to your F5 representative.

{{<call-out tip "Tip: automate reporting with your JWT license">}}To enable automatic reporting, [apply your JSON Web Token (JWT) license to NGINX Management Suite]({{< relref "nms/installation/add-license.md#apply-jwt-license" >}}). If needed, you can download this file from [MyF5](https://account.f5.com/myf5).{{</call-out>}}

