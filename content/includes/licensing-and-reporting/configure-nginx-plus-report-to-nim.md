---
docs:
---

1. Open port `443` for NGINX Instance Manager.

2. On each NGINX Plus instance, update the [`usage_report`](https://nginx.org/en/docs/ngx_mgmt_module.html#usage_report) directive in the [`mgmt`](https://nginx.org/en/docs/ngx_mgmt_module.html) block of the NGINX configuration (`/etc/nginx/nginx.conf`) to point to your NGINX Instance Manager host:

    ```nginx
    mgmt {
      usage_report endpoint=<NGINX-INSTANCE-MANAGER-FQDN>;
    }
    ```

    {{<call-out "note" "Extra steps for self-signed certificates">}}If you use self-signed certificates in your NGINX Instance Manager environment, follow the steps in [Configure SSL verification for usage reporting with self-signed certificates]({{< relref "nim/system-configuration/secure-traffic.md#configure-ssl-verify" >}}).{{</call-out>}}

3. Reload NGINX:

    ``` bash
    nginx -s reload
    ```
