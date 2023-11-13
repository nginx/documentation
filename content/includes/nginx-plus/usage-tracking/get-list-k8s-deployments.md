---
docs:
---

To report your NGINX Ingress Controller clusters to F5, follow these steps:

1. Run the following command in your terminal to get a list of NGINX Ingress Controller instances and nodes in your cluster. Remember to replace `<NMS_FQDN>` with the fully-qualified domain name of your NGINX Management Suite host:

   ```sh
   curl -X GET --url "https://<NMS_FQDN>/api/platform/v1/k8s-usage"
   ```

2. Once you have the list of instances and nodes, send it to your F5 representative.

{{<call-out tip "Tip for Automated Reporting">}}
For automatic reporting, apply your JSON Web Token (JWT) license to the NGINX Management Suite. Instructions for applying the JWT license can be found [here]({{< relref "nms/installation/add-license.md#apply-jwt-license" >}}). If you need to download the JWT license, visit [MyF5](https://account.f5.com/myf5).
{{</call-out>}}
