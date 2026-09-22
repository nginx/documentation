---
f5-product: F5 NGINXaaS
f5-files:
- content/nginxaas/aws/quickstart/pqc.md
- content/nginxaas/google/quickstart/pqc.md
---

Because hybrid ML-KEM key exchange applies only to TLS 1.3 connections, allowing TLS 1.2 means some clients can still negotiate a purely classical handshake. To prevent a downgrade, restrict `ssl_protocols` to `TLSv1.3` only:

1. Select **Configurations** in the left menu.
1. Select the ellipsis (three dots) next to your configuration and select **Edit**.
1. Add `ssl_protocols TLSv1.3;` to your `server` block:

    ```nginx
    server {
        listen 443 ssl;
        ssl_protocols TLSv1.3;
        ssl_certificate     /etc/nginx/certs/server.crt;
        ssl_certificate_key /etc/nginx/certs/server.key;
        # ...
    }
    ```

1. Select **Next** and then **Save** to apply the change.
1. Deploy configuration to relevant deployments.

{{< call-out class="note" title="Client compatibility" >}}
Restricting to TLSv1.3 drops support for clients that only support TLS 1.2. If you need to support older clients, keep the default `ssl_protocols` value and accept that those connections won't use ML-KEM.
{{< /call-out >}}
