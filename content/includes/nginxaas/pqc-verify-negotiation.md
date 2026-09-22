---
f5-product: F5 NGINXaaS
f5-files:
- content/nginxaas/aws/quickstart/pqc.md
- content/nginxaas/google/quickstart/pqc.md
---

To confirm that a client is negotiating a post-quantum key exchange group with your deployment, inspect the TLS handshake from the client side using OpenSSL:

```shell
openssl s_client -connect <YOUR_DEPLOYMENT_ENDPOINT>:443 -groups X25519MLKEM768
```

In the output, look for the `Negotiated TLS1.3 group` line. A successful hybrid negotiation shows:

```text
Negotiated TLS1.3 group: X25519MLKEM768
```

If you see `X25519` or another classical group instead, confirm that `ssl_protocols TLSv1.3;` is set, and that no `ssl_ecdh_curve` directive is overriding the defaults with classical-only groups.
