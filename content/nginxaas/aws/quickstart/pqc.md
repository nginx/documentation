---
title: Enable post-quantum cryptography
description: "Configure F5 NGINXaaS for AWS to use hybrid ML-KEM key exchange or ML-DSA certificates for post-quantum TLS protection."
weight: 100
toc: true
f5-docs: DOCS-000
url: /nginxaas/aws/quickstart/pqc/
f5-content-type: how-to
f5-product: NGINXaaS for AWS
f5-keywords: "NGINXaaS for AWS, PQC, post-quantum cryptography, ML-KEM, ML-DSA, TLS 1.3, hybrid mode, quantum-safe"
f5-summary: >
  Learn how to enable post-quantum cryptography in F5 NGINXaaS for AWS using hybrid ML-KEM key exchange or ML-DSA certificates.
  This guide covers both modes, key format requirements, and optional NGINX configuration for hardening.
f5-audience: operator
---

Post-quantum cryptography (PQC) protects TLS connections against future quantum computers. A quantum computer powerful enough to break current public-key algorithms (RSA, ECC) could decrypt traffic captured today - the "harvest now, decrypt later" threat. F5 NGINXaaS for AWS addresses this with two modes:

- **Hybrid mode**: Combines classical elliptic-curve key exchange (EC) with ML-KEM for data encryption. This protects against quantum attacks while staying compatible with clients that don't yet support PQC.
- **Full PQC mode**: Uses ML-DSA certificates and keys that you provide. This gives you a fully post-quantum TLS stack when both client and server support it.

## Before you begin

Before you begin, ensure you have:

- **An existing NGINXaaS for AWS deployment**: See [Create a deployment]({{< ref "/nginxaas/aws/deploy/create-deployment/deploy-console.md" >}}) if you need to create one.
- **TLS 1.3 in your NGINX configuration**: NGINX includes TLSv1.3 in its default `ssl_protocols` value alongside TLSv1.2. ML-KEM hybrid key exchange only applies to TLS 1.3 connections. To prevent clients from downgrading to TLS 1.2, restrict `ssl_protocols` to `TLSv1.3` only - this is recommended for maximum security but drops support for older clients.

---

## Enable hybrid mode (ML-KEM key exchange)

Hybrid mode is active by default. NGINX includes TLSv1.3 in its default `ssl_protocols` value, and ML-KEM hybrid groups are part of the default key exchange group list. No configuration changes are required in the NGINXaaS console for hybrid mode to work.

Clients that support ML-KEM will negotiate it automatically on TLS 1.3 connections. Clients that don't support ML-KEM fall back to classical key exchange.

### Recommended: Restrict to TLS 1.3 only

Because hybrid ML-KEM key exchange applies only to TLS 1.3 connections, allowing TLS 1.2 means some clients can still negotiate a purely classical handshake. To prevent downgrade, restrict `ssl_protocols` to `TLSv1.3` only:

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

### Optional: Explicitly configure ML-KEM hybrid groups

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

---

## Enable full PQC mode (ML-DSA certificates)

Full PQC mode requires you to upload an ML-DSA certificate and private key. NGINXaaS for AWS accepts ML-DSA keys in PEM format with the following constraints:

- **NGINXaaS Console**: Seed-only key format only.
- **AWS Secrets Manager**: Seed-only and seed-priv formats are both supported.

Choose the method that matches your key format.

### Upload an ML-DSA certificate using the Console

Use this method if your ML-DSA private key is in seed-only format.

1. Follow the steps in [Add certificates using the Console]({{< ref "/nginxaas/aws/deploy/ssl-tls-certificates/ssl-tls-certificates-console.md" >}}) to upload your ML-DSA certificate and key.
1. In your NGINX configuration, reference the certificate and key with `ssl_certificate` and `ssl_certificate_key`, and set `ssl_protocols TLSv1.3;`:

    ```nginx
    server {
        listen 443 ssl;
        ssl_protocols TLSv1.3;
        ssl_certificate     /etc/nginx/certs/mldsa.crt;
        ssl_certificate_key /etc/nginx/certs/mldsa.key;
        # ...
    }
    ```

1. Select **Next** and then **Save** to apply the change.
1. Deploy configuration to relevant deployments.

### Store an ML-DSA certificate in AWS Secrets Manager

Use this method if your ML-DSA private key is in seed-priv format, or if you want to keep your keys within AWS.

1. Add your ML-DSA certificate and key to AWS Secrets Manager. Follow the steps in [Add an SSL/TLS certificate to AWS Secrets Manager]({{< ref "/nginxaas/aws/deploy/ssl-tls-certificates/ssl-tls-certificates-secrets-manager.md#add-an-ssltls-certificate-to-aws-secrets-manager" >}}).
1. Reference the secret in your NGINX configuration as described in [Use an AWS Secrets Manager certificate in an NGINX configuration]({{< ref "/nginxaas/aws/deploy/ssl-tls-certificates/ssl-tls-certificates-secrets-manager.md#use-an-aws-secrets-manager-certificate-in-an-nginx-configuration" >}}).
1. Add `ssl_protocols TLSv1.3;` to your `server` block.

---

## Verify post-quantum negotiation

To confirm that a client is negotiating a post-quantum key exchange group with your deployment, inspect the TLS handshake from the client side using OpenSSL:

```shell
openssl s_client -connect <YOUR_DEPLOYMENT_ENDPOINT>:443 -groups X25519MLKEM768
```

In the output, look for the `Negotiated TLS1.3 group` line. A successful hybrid negotiation shows:

```text
Negotiated TLS1.3 group: X25519MLKEM768
```

If you see `X25519` or another classical group instead, check that `ssl_protocols TLSv1.3;` is set, and that no `ssl_ecdh_curve` directive is overriding the defaults with classical-only groups.

### Track ML-KEM adoption across real clients

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

{{< call-out class="note" title="Collecting logs" >}}
To forward logs to AWS CloudWatch, see [Enable NGINX logs]({{< ref "/nginxaas/aws/monitoring/enable-nginx-logs.md" >}}).
{{< /call-out >}}

---

## What's next

- [SSL/TLS certificate overview]({{< ref "/nginxaas/aws/deploy/ssl-tls-certificates/overview.md" >}}) - supported certificate types, formats, and rotation options.
- [Add certificates using the Console]({{< ref "/nginxaas/aws/deploy/ssl-tls-certificates/ssl-tls-certificates-console.md" >}}) - manage certificates alongside your NGINX configuration.
- [Add certificates from AWS Secrets Manager]({{< ref "/nginxaas/aws/deploy/ssl-tls-certificates/ssl-tls-certificates-secrets-manager.md" >}}) - fetch secrets directly from AWS Secrets Manager.
