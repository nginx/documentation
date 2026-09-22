---
f5-product: F5 NGINXaaS
f5-files:
- content/nginxaas/aws/quickstart/pqc.md
- content/nginxaas/google/quickstart/pqc.md
---

If you want to enforce a specific group order or exclude classical-only groups, set `ssl_ecdh_curve` in your `server` block. The following snippet enables ML-KEM hybrid (`X25519MLKEM768`) first, with `X25519` as a classical fallback:

```nginx
server {
    listen 443 ssl;
    ssl_protocols TLSv1.3;
    ssl_ecdh_curve X25519MLKEM768:X25519;
    ssl_certificate     /etc/nginx/certs/server.crt;
    ssl_certificate_key /etc/nginx/certs/server.key;
    # ...
}
```

{{< call-out class="note" title="Fallback behavior" >}}
Including `X25519` after `X25519MLKEM768` lets clients that don't support ML-KEM fall back to classical key exchange. Remove `X25519` only if you want to restrict connections to ML-KEM-capable clients.
{{< /call-out >}}
