---
title: "Runtime State Sharing"
weight: 100
categories: ["tasks"]
toc: true
docs: "DOCS-1499"
url: /nginxaas/azure/quickstart/runtime-state-sharing/
---

F5 NGINX as a Service for Azure (NGINXaaS) supports runtime state sharing using the [Zone Synchronization module](https://nginx.org/en/docs/stream/ngx_stream_zone_sync_module.html) to synchronize shared memory zones across NGINXaaS instances.

With runtime state sharing, NGINXaaS instances can share some state data between them, including:

- [Sticky‑learn session persistence](https://nginx.org/en/docs/http/ngx_http_upstream_module.html#sticky_learn)
- [Rate limiting](https://nginx.org/en/docs/http/ngx_http_limit_req_module.html#limit_req_zone)
- [Key‑value store](https://nginx.org/en/docs/http/ngx_http_keyval_module.html#keyval_zone)

{{<note>}}`sync` parameter with a directive describing shared memory zones, cannot be added to an existing memory zone that was not configured to sync and cannot be removed from an existing memory zone that was configured to sync. To switch, consider removing the directive before reapplying it with the desired parameters.{{</note>}}

For information on enabling synchronization for rate limiting with NGINXaaS for Azure, please visit the [Rate Limiting]({{< relref "/nginxaas-azure/quickstart/rate-limiting.md" >}}) documentation.

## Configuring runtime state sharing among NGINXaaS for Azure deployment cluster instances

To enable runtime state sharing, edit the NGINXaaS deployment's NGINX configuration to create a server with the `zone_sync` directive in the top-level `stream` block. The `stream` `server` block containing the `zone_sync` directive should use a local resolver at `127.0.0.1:49153` and provide a `listen` directive with only a port for the TCP server. The chosen port should match the port used with `zone_sync_server` directive. NGINXaaS cluster instances should be identified using domain name `internal.nginxaas.nginx.com` and resolved using `resolve` parameter of the `zone_sync_server` directive.

```nginx
stream {
  resolver 127.0.0.1:49153 valid=20s;

  server {
    listen 9000; # should match the port specified with zone_sync_server

    zone_sync;
    zone_sync_server internal.nginxaas.nginx.com:9000 resolve;
  }
}
```

{{<note>}}To enhance security, set up security rules for both incoming and outgoing traffic in the virtual network linked to the NSG of the subnet hosting NGINXaaS for Azure deployment. These rules should limit TCP traffic to the `zone_sync_server` port.{{</note>}}

## Enable the SSL/TLS protocol for connections to another cluster instance of the NGINXaaS for Azure deployment

 To allow SSL connections between cluster instances, edit the NGINXaaS deployment's NGINX configuration to enable the  `zone_sync_ssl` directive along with `zone_sync` directive in the top-level `stream` block.  The `stream` `server` block containing the `zone_sync_ssl` directive should specify the `ssl` parameter with the `listen` directive for the TCP server. `ssl_certificate` and `ssl_certificate_key` directives can reference a Key Vault certificate attached to the deployment.

```nginx
stream {
  resolver 127.0.0.1:49153 valid=20s;

  server {
    listen 9000 ssl;

    ssl_certificate     /opt/ssl/server.crt;
    ssl_certificate_key /opt/ssl/server.key;

    zone_sync;
    zone_sync_server internal.nginxaas.nginx.com:9000 resolve;
    zone_sync_ssl    on;
  }
}
```

## Enable verification of certificate of another cluster instance of the NGINXaaS for Azure deployment

To enable verification of the cluster instance certificate edit the NGINXaaS deployment's NGINX configuration to enable the `zone_sync_ssl_verify` directive along with `zone_sync` directive in the top-level `stream` block and provide the `zone_sync_ssl_trusted_certificate` directive. `zone_sync_ssl_trusted_certificate` directive can reference a Key Vault certificate attached to the deployment. The `zone_sync_ssl_name` directive if used, should provide the `name` parameter as `internal.nginxaas.nginx.com`.

```nginx
stream {
  resolver 127.0.0.1:49153 valid=20s;

  server {
    listen 9000 ssl;

    ssl_certificate     /opt/ssl/server.crt;
    ssl_certificate_key /opt/ssl/server.key;

    zone_sync;
    zone_sync_server internal.nginxaas.nginx.com:9000 resolve;

    zone_sync_ssl                     on;
    zone_sync_ssl_verify              on;
    zone_sync_ssl_trusted_certificate /opt/ssl/server_ca.pem;
  }
}
```

## Set up certificate-based authentication across cluster instances of the NGINXaaS for Azure deployment

To set up certificate-based authentication across the cluster instances edit the NGINXaaS deployment's NGINX configuration to enable the `ssl_verify_client` directive along with `zone_sync` directive in the top-level `stream` block and provide the `ssl_client_certificate` directive. `zone_sync_ssl_certificate`, `zone_sync_ssl_certificate_key` and `ssl_client_certificate` directives can reference a Key Vault certificate attached to the deployment.

```nginx
stream {
  resolver 127.0.0.1:49153 valid=20s;

  server {
    listen 9000 ssl;

    ssl_certificate     /opt/ssl/zone_sync.crt;
    ssl_certificate_key /opt/ssl/zone_sync.key;
    ssl_verify_client       on;
    ssl_client_certificate /opt/ssl/zone_sync_ca.pem;

    zone_sync;
    zone_sync_server internal.nginxaas.nginx.com:9000 resolve;

    zone_sync_ssl                     on;
    zone_sync_ssl_verify              on;
    zone_sync_ssl_trusted_certificate /opt/ssl/zone_sync_ca.pem;

    zone_sync_ssl_certificate     /opt/ssl/zone_sync.crt;
    zone_sync_ssl_certificate_key /opt/ssl/zone_sync.key;
  }
}
```

Refer to [Runtime State Sharing](https://docs.nginx.com/nginx/admin-guide/high-availability/zone_sync/) for guidance on using other directives from the [Zone Synchronization module](https://nginx.org/en/docs/stream/ngx_stream_zone_sync_module.html)
