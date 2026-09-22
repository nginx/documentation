---
f5-product: F5 NGINXaaS
f5-files:
- content/nginxaas/aws/quickstart/pqc.md
- content/nginxaas/google/quickstart/pqc.md
---

OpenSSL spot-checks confirm your server is ready, but they don't show which of your actual clients negotiate ML-KEM. Use the [`$ssl_curve`](https://nginx.org/en/docs/http/ngx_http_ssl_module.html#var_ssl_curve) NGINX variable to log the key exchange group negotiated for each connection, then analyze the logs to measure adoption over time.

Add a custom `log_format` and an `access_log` directive to your NGINX configuration:

```nginx
http {
    log_format pqc_tracking '$remote_addr - $ssl_protocol $ssl_curve';
    access_log /var/log/nginx/ssl-details.log pqc_tracking;
    # ...
}
```

In the logs, connections that negotiated ML-KEM hybrid key exchange appear with `X25519MLKEM768` in the `$ssl_curve` field. Classical TLS 1.3 connections appear with `X25519` or another classical group name, and TLS 1.2 connections return an empty value.
