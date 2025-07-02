---
title: Access the NGINX Plus dashboard
weight: 300
toc: true
nd-content-type: how-to
nd-product: NGF
nd-docs: DOCS-1417
---

This topic describes how to view the NGINX Plus dashboard to see real-time metrics.

The NGINX Plus dashboard offers a real-time live activity monitoring interface that shows key load and performance metrics of your server infrastructure.

The dashboard is enabled by default for NGINX Gateway Fabric deployments that use NGINX Plus as the data plane, and is available on port 8765.

## Connect to the dashboard

To access the dashboard, you will first need to forward connections to port 8765 on your local machine to port 8765 on the NGINX Plus pod (replace `<nginx-plus-pod>` with the actual name of the pod).

```shell
kubectl port-forward <nginx-plus-pod> 8765:8765 -n <nginx-plus-pod-namespace>
```

Afterwards, use a browser to access [http://127.0.0.1:8765/dashboard.html](http://127.0.0.1:8765/dashboard.html) to view the dashboard.

The dashboard will look like this:

{{< img src="/ngf/img/nginx-plus-dashboard.png" alt="">}}

{{< note >}} The [API](https://nginx.org/en/docs/http/ngx_http_api_module.html) used by the dashboard for metrics is also accessible using the `/api` path. {{< /note >}}

### Configure dashboard access through NginxProxy

To access the NGINX Plus dashboard from sources than the default `127.0.0.1`, you can use the NginxProxy resource to allow access to other IP Addresses or CIDR blocks.

The following example configuration allows access to the NGINX Plus dashboard from the IP Addresses `192.0.2.8` and
`192.0.2.0` and the CIDR block `198.51.100.0/24`:

```yaml
apiVersion: gateway.nginx.org/v1alpha1
kind: NginxProxy
metadata:
   name: ngf-proxy-config
spec:
   nginxPlus:
      allowedAddresses:
         - type: IPAddress
           value: 192.0.2.8
         - type: IPAddress
           value: 192.0.2.0
         - type: CIDR
           value: 198.51.100.0/24
```

For more information on configuring the NginxProxy resource, visit the [data plane configuration]({{< ref "/ngf/how-to/data-plane-configuration.md" >}}) document.