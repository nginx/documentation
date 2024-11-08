---
docs:
---

The [`ssl_verify`](https://nginx.org/en/docs/ngx_mgmt_module.html#ssl_verify) directive, which verifies the usage reporting endpoint's certificate, is set to `on` by default. This ensures communication is secure and protects against untrusted endpoints.

**We recommend keeping this setting enabled.**

For detailed steps on configuring `ssl_verify` for NGINX Plus instances in network-restricted environments, see [Configure SSL verification for usage reporting with self-signed certificates]({{< relref "nim/system-configuration/secure-traffic.md#configure-ssl-verify" >}}).

