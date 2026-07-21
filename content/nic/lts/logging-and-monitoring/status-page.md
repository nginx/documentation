---
title: View the NGINX status page
toc: true
weight: 200
f5-content-type: how-to
f5-product: NGINX Ingress Controller
---

This document explains how to get access to the dashboard in NGINX Plus. 

NGINX Plus comes with a [dashboard]({{< ref "/nginx/admin-guide/monitoring/live-activity-monitoring.md" >}}) that reports key load-balancing and performance metrics.

## Accessing Live Activity Monitoring Dashboard

Prerequisites:

1. The dashboard is enabled by default. Ensure that the `nginx-status` [command-line argument]({{< ref "/nic/lts/configuration/global-configuration/command-line-arguments.md" >}}) is not set to false.
1. The dashboard is available on port 8080 by default. It is customizable by the `nginx-status-port` command-line argument. If yours is not on 8080, modify the kubectl proxy command below.

To access the dashboard:

1. Use the `kubectl port-forward` command to forward connections to port 8080 on your local machine to port 8080 of an NGINX Plus Ingress Controller pod (replace `<nginx-plus-ingress-pod>` with the actual name of a pod):

    ```shell
    kubectl port-forward <nginx-plus-ingress-pod> 8080:8080 --namespace=nginx-ingress
    ```

1. Open your browser at <http://127.0.0.1:8080/dashboard.html> to access the dashboard.

If you want to access the dashboard externally (without `kubectl port-forward`):

1. Configure `-nginx-status-allow-cidrs` command-line argument with IP/CIDR blocks for which you want to allow access to the dashboard. By default, the access is allowed for `127.0.0.1,::1`.
1. Use the IP/port through which the Ingress Controller pod/pods are available to connect the dashboard at the `/dashboard.html` path.

**Note**: The [API](https://nginx.org/en/docs/http/ngx_http_api_module.html), which the dashboard uses to get the metrics, is also accessible: use the `/api` path. For App Protect DoS use the `/api/dos` path. Note that the API is configured in the read-only mode.
