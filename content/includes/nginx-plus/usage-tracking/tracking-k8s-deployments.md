---
docs:
---

You can set up your Kubernetes-based NGINX products, including [NGINX Ingress Controller](https://www.nginx.com/products/nginx-ingress-controller/) and [Connectivity Stack for Kubernetes](https://www.nginx.com/solutions/kubernetes/), to report data directly to the NGINX Instance Manager API.

To configure reporting for your NGINX Kubernetes products, follow these steps:

1. **Configure usage reporting for NGINX Kubernetes**: Follow the instructions in the [Enabling Usage Reporting](https://docs.nginx.com/nginx-ingress-controller/usage-reporting/) guide to enable usage reporting for NGINX Ingress Controller.
1. **Query the Kubernetes Usage API**: Use the following `curl` command to get a list of clusters and relevant deployment information, including node and pod counts:

   ```sh
   curl -X GET --url "https://<NMS_FQDN>/api/platform/v1/k8s-usage"
   ```

1. **Apply a JWT License (Optional)**: Follow these steps to [apply a JWT license]({{< relref "nms/installation/add-license.md#apply-jwt-license" >}}). 

   To compare your usage with your entitled capacity, go to the **Settings > License** page in NGINX Management Suite.

   You have the option to regularly send usage data to F5 by enabling **Continuous Connection** on the **Licensing** page. Alternatively, you can submit data on-demand by selecting the **Send Usage to F5** button.
