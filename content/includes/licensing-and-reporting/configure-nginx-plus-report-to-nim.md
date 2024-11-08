---
docs:
---

1. Open port `443` for NGINX Instance Manager.

2. On each NGINX Plus instance, update the [`usage_report`](https://nginx.org/en/docs/ngx_mgmt_module.html#usage_report) directive in the [`mgmt`](https://nginx.org/en/docs/ngx_mgmt_module.html) block of the NGINX configuration (`/etc/nginx/nginx.conf`) to point to your NGINX Instance Manager host:

    ``` nginx
    mgmt {
      usage_report endpoint=<NGINX-INSTANCE-MANAGER-FQDN>;
    }
    ```

    {{<call-out "note" "Extra setup for self-signed certificates">}}If your NGINX Instance Manager environment uses self-signed certificates, see [Configure SSL verification for usage reporting with self-signed certificates]({{< relref "nim/system-configuration/secure-traffic.md#configure-ssl-verify" >}}).{{</call-out>}}

3. Validate the configuration and reload NGINX:

    ``` bash
    nginx -s reload
    ```
