---
f5-product: F5 NGINXaaS
f5-files:
- content/nginxaas/aws/quickstart/pqc.md
- content/nginxaas/google/quickstart/pqc.md
---

Hybrid mode is active by default. NGINX includes TLSv1.3 in its default `ssl_protocols` value, and ML-KEM hybrid groups are part of the default key exchange group list. No configuration changes are required in the NGINXaaS console for hybrid mode to work.

Clients that support ML-KEM will negotiate it automatically on TLS 1.3 connections. Clients that don't support ML-KEM fall back to classical key exchange.
