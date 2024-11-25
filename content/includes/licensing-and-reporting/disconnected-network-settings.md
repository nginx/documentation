---
docs:
---

1. On each NGINX Plus instance, update the `usage_report` directive in the [`mgmt`](https://nginx.org/en/docs/ngx_mgmt_module.html) block of the NGINX configuration (**/etc/nginx/nginx.conf**) to point to your NGINX Instance Manager host:

   ``` nginx
   usage_report endpoint=<NGINX_INSTANCE_MANAGER_HOST_FQDN> interval=1hr;
   ```

1. **Open port 443 for NGINX Instance Manager**:  
   Ensure NGINX Plus can connect to NGINX Instance Manager to report usage data.

If NGINX Instance Manager has internet access, it will automatically report usage data to F5. If it doesn't doesn't have internet access, you can manually [submit usage reports to F5 for verification and acknowledgement]({{< relref "nim/disconnected/report-usage-disconnected-deployment.md" >}}).
