---
---

1. Allow NGINX Plus instances to connect to NGINX Instance Manager over HTTPS (TCP `443`).

1. On each NGINX Plus instance, set the [`usage_report`](https://nginx.org/en/docs/ngx_mgmt_module.html#usage_report) directive in the [`mgmt`](https://nginx.org/en/docs/ngx_mgmt_module.html) block of `/etc/nginx/nginx.conf` to point to your NGINX Instance Manager host:

    ```nginx
    mgmt {
     usage_report endpoint=<NGINX-INSTANCE-MANAGER-FQDN>;
    }
    ```

1. Reload NGINX:

    ``` bash
    systemctl reload nginx
    ```

{{<call-out "note" "If you’re using self-signed certificates" >}}
If you’re using self-signed certificates with NGINX Instance Manager,  
see [Configure SSL verification for self-signed certificates]({{< ref "nim/system-configuration/secure-traffic.md#configure-ssl-verify" >}}) for additional steps.
{{</call-out>}}
