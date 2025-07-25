---
title: ConfigMap resources
weight: 300
toc: true
nd-content-type: how-to
nd-product: NIC
nd-docs: DOCS-586
---

When using F5 NGINX Ingress Controller, you can customize or fine tune NGINX behavior using ConfigMap resources. Examples include setting the number of worker processes or customizing the access log format.

## Using ConfigMap

1. The [Installation with Manifests]({{< ref "/nic/installation/installing-nic/installation-with-manifests.md" >}}) documentation deploy an empty ConfigMap while the default installation manifests specify it in the command-line arguments of the Ingress Controller. However, if you customized the manifests, to use ConfigMap, make sure to specify the ConfigMap resource to use the [command-line arguments]({{< ref "/nic/configuration/global-configuration/command-line-arguments" >}}) of NGINX Ingress Controller.

1. Create a ConfigMap file with the name *nginx-config.yaml* and set the values
that make sense for your setup:

    ```yaml
    kind: ConfigMap
    apiVersion: v1
    metadata:
      name: nginx-config
      namespace: nginx-ingress
    data:
      proxy-connect-timeout: "10s"
      proxy-read-timeout: "10s"
      client-max-body-size: "2m"
    ```

    See the section [Summary of ConfigMap Keys](#summary-of-configmap-keys) for the explanation of the available ConfigMap keys (such as `proxy-connect-timeout` in this example).

1. Create a new (or update the existing) ConfigMap resource:

    ```shell
    kubectl apply -f nginx-config.yaml
    ```

    The NGINX configuration will be updated.

---

## ConfigMap and Ingress annotations

ConfigMap applies globally, meaning that it affects every Ingress resource. In contrast, annotations always apply to their Ingress resource. Annotations can override some ConfigMap keys: an example is that the `nginx.org/proxy-connect-timeout` annotations overrides the `proxy-connect-timeout` ConfigMap key.

For more information, view the [Advanced configuration with annotations]({{< ref "/nic/configuration/ingress-resources/advanced-configuration-with-annotations" >}}) topic.

---

## ConfigMap and VirtualServer/VirtualServerRoute resources

The ConfigMap affects every VirtualServer and VirtualServerRoute resources. However, the fields of those resources allow overriding some ConfigMap keys. For example, the `connect-timeout` field of the `upstream` overrides the `proxy-connect-timeout` ConfigMap key.

For more information, view the [VirtualServer and VirtualServerRoute resources]({{< ref "/nic/configuration/virtualserver-and-virtualserverroute-resources" >}}) topic.

---

## ConfigMap keys

### Ingress Controller (Unrelated to NGINX Configuration)

{{<bootstrap-table "table table-striped table-bordered table-responsive">}}
|ConfigMap Key | Description | Default | Example |
| ---| ---| ---| --- |
|*external-status-address* | Sets the address to be reported in the status of Ingress resources. Requires the *-report-status* command-line argument. Overrides the *-external-service* argument. | N/A | [Reporting resource status]({{< ref "/nic/configuration/global-configuration/reporting-resources-status" >}}) |
{{</bootstrap-table>}}

---

### General customization

{{<bootstrap-table "table table-striped table-bordered table-responsive">}}
|ConfigMap Key | Description | Default | Example |
| ---| ---| ---| --- |
|*proxy-connect-timeout* | Sets the value of the [proxy_connect_timeout](https://nginx.org/en/docs/http/ngx_http_proxy_module.html#proxy_connect_timeout) and [grpc_connect_timeout](https://nginx.org/en/docs/http/ngx_http_grpc_module.html#grpc_connect_timeout) directive. | *60s* |  |
|*proxy-read-timeout* | Sets the value of the [proxy_read_timeout](https://nginx.org/en/docs/http/ngx_http_proxy_module.html#proxy_read_timeout) and [grpc_read_timeout](https://nginx.org/en/docs/http/ngx_http_grpc_module.html#grpc_read_timeout) directive. | *60s* |  |
|*proxy-send-timeout* | Sets the value of the [proxy_send_timeout](https://nginx.org/en/docs/http/ngx_http_proxy_module.html#proxy_send_timeout) and [grpc_send_timeout](https://nginx.org/en/docs/http/ngx_http_grpc_module.html#grpc_send_timeout) directive. | *60s* |  |
|*client-max-body-size* | Sets the value of the [client_max_body_size](https://nginx.org/en/docs/http/ngx_http_core_module.html#client_max_body_size) directive. | *1m* |  |
|*proxy-buffering* | Enables or disables [buffering of responses](https://nginx.org/en/docs/http/ngx_http_proxy_module.html#proxy_buffering) from the proxied server. | *True* |  |
|*proxy-buffers* | Sets the value of the [proxy_buffers](https://nginx.org/en/docs/http/ngx_http_proxy_module.html#proxy_buffers) directive. | Depends on the platform. |  |
|*proxy-buffer-size* | Sets the value of the [proxy_buffer_size](https://nginx.org/en/docs/http/ngx_http_proxy_module.html#proxy_buffer_size) and [grpc_buffer_size](https://nginx.org/en/docs/http/ngx_http_grpc_module.html#grpc_buffer_size) directives. | Depends on the platform. |  |
|*proxy-max-temp-file-size* | Sets the value of the  [proxy_max_temp_file_size](https://nginx.org/en/docs/http/ngx_http_proxy_module.html#proxy_max_temp_file_size) directive. | *1024m* |  |
|*set-real-ip-from* | Sets the value of the [set_real_ip_from](https://nginx.org/en/docs/http/ngx_http_realip_module.html#set_real_ip_from) directive. | N/A |  |
|*real-ip-header* | Sets the value of the [real_ip_header](https://nginx.org/en/docs/http/ngx_http_realip_module.html#real_ip_header) directive. | *X-Real-IP* |  |
|*real-ip-recursive* | Enables or disables the [real_ip_recursive](https://nginx.org/en/docs/http/ngx_http_realip_module.html#real_ip_recursive) directive. | *False* |  |
|*default-server-return* | Configures the [return](https://nginx.org/en/docs/http/ngx_http_rewrite_module.html#return)  directive in the default server, which handles a client request if none of the hosts of Ingress or VirtualServer resources match. The default value configures NGINX to return a 404 error page. You can configure a fixed response or a redirect. For example, *default-server-return: 302 https://nginx.org* will redirect a client to *https://nginx.org*. | *404* |  |
|*server-tokens* | Enables or disables the [server_tokens](https://nginx.org/en/docs/http/ngx_http_core_module.html#server_tokens) directive. Additionally, with the NGINX Plus, you can specify a custom string value, including the empty string value, which disables the emission of the “Server” field. | *True* |  |
|*worker-processes* | Sets the value of the [worker_processes](https://nginx.org/en/docs/ngx_core_module.html#worker_processes) directive. | *auto* |  |
|*worker-rlimit-nofile* | Sets the value of the [worker_rlimit_nofile](https://nginx.org/en/docs/ngx_core_module.html#worker_rlimit_nofile) directive. | N/A |  |
|*worker-connections* | Sets the value of the [worker_connections](https://nginx.org/en/docs/ngx_core_module.html#worker_connections) directive. | *1024* |  |
|*worker-cpu-affinity* | Sets the value of the [worker_cpu_affinity](https://nginx.org/en/docs/ngx_core_module.html#worker_cpu_affinity) directive. | N/A |  |
|*worker-shutdown-timeout* | Sets the value of the [worker_shutdown_timeout](https://nginx.org/en/docs/ngx_core_module.html#worker_shutdown_timeout) directive. | N/A |  |
|*server-names-hash-bucket-size* | Sets the value of the [server_names_hash_bucket_size](https://nginx.org/en/docs/http/ngx_http_core_module.html#server_names_hash_bucket_size) directive. | *256* |  |
|*server-names-hash-max-size* | Sets the value of the [server_names_hash_max_size](https://nginx.org/en/docs/http/ngx_http_core_module.html#server_names_hash_max_size) directive. | *1024* |  |
|*map-hash-bucket-size* | Sets the value of the [map_hash_bucket_size](http://nginx.org/en/docs/http/ngx_http_map_module.html#map_hash_bucket_size) directive.| *256* |  |
|*map-hash-max-size* | Sets the value of the [map_hash_max_size](http://nginx.org/en/docs/http/ngx_http_map_module.html#map_hash_max_size) directive. | *2048* |  |
|*resolver-addresses* | Sets the value of the [resolver](https://nginx.org/en/docs/http/ngx_http_core_module.html#resolver) addresses. Note: If you use a DNS name (for example, *kube-dns.kube-system.svc.cluster.local* ) as a resolver address, NGINX Plus will resolve it using the system resolver during the start and on every configuration reload. If the name cannot be resolved or the DNS server doesn't respond, NGINX Plus will fail to start or reload. To avoid this, we recommend using IP addresses as resolver addresses instead of DNS names. Supported in NGINX Plus only. | N/A | [Support for Type ExternalName Services](https://github.com/nginx/kubernetes-ingress/tree/v{{< nic-version >}}/examples/ingress-resources/externalname-services). |
|*resolver-ipv6* | Enables IPv6 resolution in the resolver. Supported in NGINX Plus only. | *True* | [Support for Type ExternalName Services](https://github.com/nginx/kubernetes-ingress/tree/v{{< nic-version >}}/examples/ingress-resources/externalname-services). |
|*resolver-valid* | Sets the time NGINX caches the resolved DNS records. Supported in NGINX Plus only. | TTL value of a DNS record | [Support for Type ExternalName Services](https://github.com/nginx/kubernetes-ingress/tree/v{{< nic-version >}}/examples/ingress-resources/externalname-services). |
|*resolver-timeout* | Sets the [resolver_timeout](https://nginx.org/en/docs/http/ngx_http_core_module.html#resolver_timeout) for name resolution. Supported in NGINX Plus only. | *30s* | [Support for Type ExternalName Services](https://github.com/nginx/kubernetes-ingress/tree/v{{< nic-version >}}/examples/ingress-resources/externalname-services). |
|*keepalive-timeout* | Sets the value of the [keepalive_timeout](https://nginx.org/en/docs/http/ngx_http_core_module.html#keepalive_timeout) directive. | *75s* |  |
|*keepalive-requests* | Sets the value of the [keepalive_requests](https://nginx.org/en/docs/http/ngx_http_core_module.html#keepalive_requests) directive. | *1000* |  |
|*variables-hash-bucket-size* | Sets the value of the [variables_hash_bucket_size](https://nginx.org/en/docs/http/ngx_http_core_module.html#variables_hash_bucket_size) directive. | *256* |  |
|*variables-hash-max-size* | Sets the value of the [variables-hash-max-size](https://nginx.org/en/docs/http/ngx_http_core_module.html#variables_hash_max_size) directive. | *1024* |  |
{{</bootstrap-table>}}

---

### Logging

{{<bootstrap-table "table table-striped table-bordered table-responsive">}}
|ConfigMap Key | Description | Default | Example |
| ---| ---| ---| --- |
|*error-log-level* | Sets the global [error log level](https://nginx.org/en/docs/ngx_core_module.html#error_log) for NGINX. | *notice* |  |
|*access-log* | Sets the directive [access log](https://nginx.org/en/docs/http/ngx_http_log_module.html#access_log). A syslog destination is the only valid value. The value will be set to its default in-case user tries to configure it with location other than a syslog.
| ``/dev/stdout main`` | ``syslog:server=localhost:514`` |
|*access-log-off* | Disables the [access log](https://nginx.org/en/docs/http/ngx_http_log_module.html#access_log). | *False* |  |
|*default-server-access-log-off* | Disables the [access log](https://nginx.org/en/docs/http/ngx_http_log_module.html#access_log) for the default server. If access log is disabled globally (*access-log-off: "True"*), then the default server access log is always disabled. | *False* |  |
|*log-format* | Sets the custom [log format](https://nginx.org/en/docs/http/ngx_http_log_module.html#log_format) for HTTP and HTTPS traffic. For convenience, it is possible to define the log format across multiple lines (each line separated by *\n*). In that case, the Ingress Controller will replace every *\n* character with a space character. All *'* characters must be escaped. | See the [template file](https://github.com/nginx/kubernetes-ingress/blob/v{{< nic-version >}}/internal/configs/version1/nginx.tmpl) for the access log. | [Custom Log Format](https://github.com/nginx/kubernetes-ingress/tree/v{{< nic-version >}}/examples/shared-examples/custom-log-format). |
|*log-format-escaping* | Sets the characters escaping for the variables of the log format. Supported values: *json* (JSON escaping), *default* (the default escaping) *none* (disables escaping). | *default* |  |
|*stream-log-format* | Sets the custom [log format](https://nginx.org/en/docs/stream/ngx_stream_log_module.html#log_format) for TCP, UDP, and TLS Passthrough traffic. For convenience, it is possible to define the log format across multiple lines (each line separated by *\n*). In that case, the Ingress Controller will replace every *\n* character with a space character. All *'* characters must be escaped. | See the [template file](https://github.com/nginx/kubernetes-ingress/blob/v{{< nic-version >}}/internal/configs/version1/nginx.tmpl). |  |
|*stream-log-format-escaping* | Sets the characters escaping for the variables of the stream log format. Supported values: *json* (JSON escaping), *default* (the default escaping) *none* (disables escaping). | *default* |  |
{{</bootstrap-table>}}

---

### Request URI/Header manipulation

{{<bootstrap-table "table table-striped table-bordered table-responsive">}}
|ConfigMap Key | Description | Default | Example |
| ---| ---| ---| --- |
|*proxy-hide-headers* | Sets the value of one or more  [proxy_hide_header](https://nginx.org/en/docs/http/ngx_http_proxy_module.html#proxy_hide_header) directives. Example: *"nginx.org/proxy-hide-headers": "header-a,header-b"* | N/A |  |
|*proxy-pass-headers* | Sets the value of one or more   [proxy_pass_header](https://nginx.org/en/docs/http/ngx_http_proxy_module.html#proxy_pass_header) directives. Example: *"nginx.org/proxy-pass-headers": "header-a,header-b"* | N/A |  |
{{</bootstrap-table>}}

---

### Auth and SSL/TLS

{{<bootstrap-table "table table-striped table-bordered table-responsive">}}
|ConfigMap Key | Description | Default | Example |
| ---| ---| ---| --- |
|*redirect-to-https* | Sets the 301 redirect rule based on the value of the *http_x_forwarded_proto* header on the server block to force incoming traffic to be over HTTPS. Useful when terminating SSL in a load balancer in front of the Ingress Controller — see [115](https://github.com/nginx/kubernetes-ingress/issues/115) | *False* |  |
|*ssl-redirect* | Sets an unconditional 301 redirect rule for all incoming HTTP traffic to force incoming traffic over HTTPS. | *True* |  |
|*hsts* | Enables [HTTP Strict Transport Security (HSTS)](https://www.nginx.com/blog/http-strict-transport-security-hsts-and-nginx/) : the HSTS header is added to the responses from backends. The *preload* directive is included in the header. | *False* |  |
|*hsts-max-age* | Sets the value of the *max-age* directive of the HSTS header. | *2592000* (1 month) |  |
|*hsts-include-subdomains* | Adds the *includeSubDomains* directive to the HSTS header. | *False* |  |
|*hsts-behind-proxy* | Enables HSTS based on the value of the *http_x_forwarded_proto* request header. Should only be used when TLS termination is configured in a load balancer (proxy) in front of the Ingress Controller. Note: to control redirection from HTTP to HTTPS configure the *nginx.org/redirect-to-https* annotation. | *False* |  |
|*ssl-protocols* | Sets the value of the [ssl_protocols](https://nginx.org/en/docs/http/ngx_http_ssl_module.html#ssl_protocols) directive. | *TLSv1 TLSv1.1 TLSv1.2* |  |
|*ssl-prefer-server-ciphers* | Enables or disables the [ssl_prefer_server_ciphers](https://nginx.org/en/docs/http/ngx_http_ssl_module.html#ssl_prefer_server_ciphers) directive. | *False* |  |
|*ssl-ciphers* | Sets the value of the [ssl_ciphers](https://nginx.org/en/docs/http/ngx_http_ssl_module.html#ssl_ciphers) directive. | *HIGH:!aNULL:!MD5* |  |
|*ssl-dhparam-file* | Sets the content of the dhparam file. The controller will create the file and set the value of the [ssl_dhparam](https://nginx.org/en/docs/http/ngx_http_ssl_module.html#ssl_dhparam) directive with the path of the file. | N/A |  |
{{</bootstrap-table>}}

---

### Listeners

{{<bootstrap-table "table table-striped table-bordered table-responsive">}}
|ConfigMap Key | Description | Default | Example |
| ---| ---| ---| --- |
|*http2* | Enables HTTP/2 in servers with SSL enabled. | *False* |  |
|*proxy-protocol* | Enables PROXY Protocol for incoming connections. | *False* | [Proxy Protocol](https://github.com/nginx/kubernetes-ingress/tree/v{{< nic-version >}}/examples/shared-examples/proxy-protocol). |
{{</bootstrap-table>}}

---

### Backend services (Upstreams)

{{<bootstrap-table "table table-striped table-bordered table-responsive">}}
|ConfigMap Key | Description | Default | Example |
| ---| ---| ---| --- |
|*lb-method* | Sets the [load balancing method]({{< ref "/nginx/admin-guide/load-balancer/http-load-balancer.md#choosing-a-load-balancing-method" >}}). To use the round-robin method, specify *"round_robin"*. | *"random two least_conn"* |  |
|*max-fails* | Sets the value of the [max_fails](https://nginx.org/en/docs/http/ngx_http_upstream_module.html#max_fails) parameter of the *server* directive. | *1* |  |
|*upstream-zone-size* | Sets the size of the shared memory [zone](https://nginx.org/en/docs/http/ngx_http_upstream_module.html#zone) for upstreams. For NGINX, the special value 0 disables the shared memory zones. For NGINX Plus, shared memory zones are required and cannot be disabled. The special value 0 will be ignored. | *256k* for NGINX, *512k* for NGINX Plus  |  |
|*fail-timeout* | Sets the value of the [fail_timeout](https://nginx.org/en/docs/http/ngx_http_upstream_module.html#fail_timeout) parameter of the *server* directive. | *10s* |  |
|*keepalive* | Sets the value of the [keepalive](https://nginx.org/en/docs/http/ngx_http_upstream_module.html#keepalive) directive. Note that *proxy_set_header Connection "";* is added to the generated configuration when the value > 0. | *0* |  |
{{</bootstrap-table>}}

---

### Zone Sync

Zone Sync enables the [ngx_stream_zone_sync_module](https://nginx.org/en/docs/stream/ngx_stream_zone_sync_module.html) in NGINX Ingress Controller when NGINX Plus is used.  Multiple replicas are required to effectively utililise this functionality. More information is available in the [How NGINX Plus Performs Zone Synchronization]({{< ref "/nginx/admin-guide/high-availability/zone_sync_details.md" >}}) topic.

Zone synchronization with TLS for NGINX Ingress Controller is not yet available with ConfigMap. If you would like to enable Zone Sync with TLS, please remove `zone-sync` from ConfigMap and add Zone Sync parameters via [`stream-snippets`]({{< ref "/nic/configuration/ingress-resources/advanced-configuration-with-snippets.md" >}}) similar to [this example](https://github.com/nginx/kubernetes-ingress/blob/v4.0.1/examples/custom-resources/oidc/nginx-config.yaml) and adding the [zone_sync_ssl directive](https://nginx.org/en/docs/stream/ngx_stream_zone_sync_module.html#zone_sync_ssl) along with any other TLS parameters to the `stream-snippets`.

You will also need to manually add the headless service, such as in [this example](https://github.com/nginx/kubernetes-ingress/blob/v4.0.1/examples/custom-resources/oidc/nginx-ingress-headless.yaml).

{{< caution >}}
If you previously installed OIDC or used the `zone_sync` directive with `stream-snippets` in [v4.0.1](https://github.com/nginx/kubernetes-ingress/tree/v4.0.1) or earlier, and you plan to enable the `zone-sync` ConfigMap key, the `zone_sync` directive should be removed from `stream-snippets`.

If you encounter the error `error [emerg] 13#13: "zone_sync" directive is duplicate in /etc/nginx/nginx.conf:164` it is likely due to `zone_sync` being enabled in both `stream-snippets` and the ConfigMap. Once upgraded, remove the [old headless service](https://github.com/nginx/kubernetes-ingress/blob/v4.0.1/examples/custom-resources/oidc/nginx-ingress-headless.yaml) deployed for OIDC.
{{< /caution >}}


{{<bootstrap-table "table table-striped table-bordered table-responsive">}}
|ConfigMap Key | Description | Default | Example |
| ---| ---| ---| --- |
|*zone-sync* | Enables zone synchronization between NGINX Ingress Controller Pods. This autogenerates a [zone_sync_server](https://nginx.org/en/docs/stream/ngx_stream_zone_sync_module.html#zone_sync_server) and a headless service using the `ReplicaSet` or `DaemonSet` name. Please note that this headless service will be automatically cleaned up when uninstalling via Helm or by removing the value from the ConfigMap. The headless service will need to be manually removed if the `controller.customConfigMap` value is set via Helm or the deployment is uninstalled via Manifests. Each Ingress Controller manages its own headless service.  NGINX Plus Required. | *False* |  |
|*zone-sync-port* | Specifies the optional port on which NGINX Ingress Controller listens for zone sync traffic. NGINX Plus & `zone-sync` Required. | *12345* |  |
|*zone-sync-resolver-addresses* | Configures optional addresses used in the [resolver](https://nginx.org/en/docs/http/ngx_http_core_module.html#resolver) directive for zone-sync. This field takes a comma separated list of addresses. NGINX Plus & `zone-sync` Required | `kube-dns.kube-system.svc.cluster.local` |  |
|*zone-sync-resolver-ipv6* | Configures whether the optional [resolver](https://nginx.org/en/docs/http/ngx_http_core_module.html#resolver) directive for zone-sync will look up IPv6 addresses. NGINX Plus & `zone-sync` Required | `true` |  |
|*zone-sync-resolver-valid* | Configures an [NGINX time](https://nginx.org/en/docs/syntax.html) that the optional [resolver](https://nginx.org/en/docs/http/ngx_http_core_module.html#resolver) directive for zone-sync will override the TTL value of responses from nameservers with. NGINX Plus & `zone-sync` Required | `5s` |  |
{{</bootstrap-table>}}

---

### Snippets and custom templates

{{<bootstrap-table "table table-striped table-bordered table-responsive">}}
|ConfigMap Key | Description | Default | Example |
| ---| ---| ---| --- |
|*main-snippets* | Sets a custom snippet in main context. | N/A |  |
|*http-snippets* | Sets a custom snippet in http context. | N/A |  |
|*location-snippets* | Sets a custom snippet in location context. | N/A |  |
|*server-snippets* | Sets a custom snippet in server context. | N/A |  |
|*stream-snippets* | Sets a custom snippet in stream context. | N/A | [Support for TCP/UDP Load Balancing](https://github.com/nginx/kubernetes-ingress/tree/v{{< nic-version >}}/examples/ingress-resources/tcp-udp). |
|*main-template* | Sets the main NGINX configuration template. | By default the template is read from the file in the container. | [Custom Templates]({{< ref "/nic/configuration/global-configuration/custom-templates.md" >}}). |
|*ingress-template* | Sets the NGINX configuration template for an Ingress resource. | By default the template is read from the file on the container. | [Custom Templates]({{< ref "/nic/configuration/global-configuration/custom-templates.md" >}}). |
|*virtualserver-template* | Sets the NGINX configuration template for an VirtualServer resource. | By default the template is read from the file on the container. | [Custom Templates]({{< ref "/nic/configuration/global-configuration/custom-templates.md" >}}). |
|*transportserver-template* | Sets the NGINX configuration template for a TransportServer resource. | By default the template is read from the file on the container. | [Custom Templates]({{< ref "/nic/configuration/global-configuration/custom-templates.md" >}}) |
{{</bootstrap-table>}}

---

### Modules

{{<bootstrap-table "table table-striped table-bordered table-responsive">}}
|ConfigMap Key | Description | Default | Example |
| ---| ---| ---| --- |
|*otel-exporter-endpoint* | OTLP/gRPC endpoint that will accept [OpenTelemetry](https://opentelemetry.io) data. Set `otel-trace-in-http` to *"true"* to enable OpenTelemetry at the global level. | N/A | *"https://otel-collector:4317"* |
|*otel-exporter-header-name* | The name of a custom HTTP header to add to telemetry export request. `otel-exporter-endpoint` and `otel-exporter-header-value` required. | N/A | *"X-custom-header"* |
|*otel-exporter-header-value* | The value of a custom HTTP header to add to telemetry export request. `otel-exporter-endpoint` and `otel-exporter-header-name` required. | N/A | *"custom-value"* |
|*otel-service-name* | Sets the `service.name` attribute of the OTel resource. `otel-exporter-endpoint` required. | N/A | *"nginx-ingress-controller:nginx"* |
| *otel-trace-in-http* | Enables [OpenTelemetry](https://opentelemetry.io) globally (for all Ingress, VirtualServer and VirtualServerRoute resources). Set this to *"false"* to enable OpenTelemetry for individual routes with snippets. `otel-exporter-endpoint` required. | *"false"* | *"true"* |
|*opentracing* | Removed in v5.0.0.  Enables [OpenTracing](https://opentracing.io) globally (for all Ingress, VirtualServer and VirtualServerRoute resources). Note: requires the Ingress Controller image with OpenTracing module and a tracer. See the [docs]({{< ref "/nic/logging-and-monitoring/opentracing.md" >}}) for more information. | *False* |  |
|*opentracing-tracer* | Removed in v5.0.0.  Sets the path to the vendor tracer binary plugin. | N/A |  |
|*opentracing-tracer-config* | Removed in v5.0.0.  Sets the tracer configuration in JSON format. | N/A |  |
|*app-protect-compressed-requests-action* | Sets the *app_protect_compressed_requests_action* [global directive](/nginx-app-protect/configuration/#global-directives). | *drop* |  |
|*app-protect-cookie-seed* | Sets the *app_protect_cookie_seed* [global directive](/nginx-app-protect/configuration/#global-directives). | Random automatically generated string |  |
|*app-protect-failure-mode-action* | Sets the *app_protect_failure_mode_action* [global directive](/nginx-app-protect/configuration/#global-directives). | *pass* |  |
|*app-protect-cpu-thresholds* | Sets the *app_protect_cpu_thresholds* [global directive](/nginx-app-protect/configuration/#global-directives). | *high=100 low=100* |  |
|*app-protect-physical-memory-util-thresholds* | Sets the *app_protect_physical_memory_util_thresholds* [global directive](/nginx-app-protect/configuration/#global-directives). | *high=100 low=100* |  |
|`app-protect-reconnect-period-seconds` | Sets the `app_protect_reconnect_period_seconds` [global directive](/nginx-app-protect/configuration/#global-directives). | `5` |  |
|*app-protect-dos-log-format* | Sets the custom [log format](https://nginx.org/en/docs/http/ngx_http_log_module.html#log_format) for Dos Access log traffic. For convenience, it is possible to define the log format across multiple lines (each line separated by *\n*). In that case, the Ingress Controller will replace every *\n* character with a space character. All *'* characters must be escaped. | `, vs_name_al=$app_protect_dos_vs_name, ip=$remote_addr, tls_fp=$app_protect_dos_tls_fp, outcome=$app_protect_dos_outcome, reason=$app_protect_dos_outcome_reason, policy_name=$app_protect_dos_policy_name, dos_version=$app_protect_dos_version, ip_tls=$remote_addr:$app_protect_dos_tls_fp,` | |
|*app-protect-dos-log-format-escaping* | Sets the characters escaping for the variables of the stream log format. Supported values: *json* (JSON escaping), *default* (the default escaping) *none* (disables escaping). | *default* |  |
|*app-protect-dos-arb-fqdn* | Sets the *app-protect-dos-arb-fqdn* [directive](/nginx-app-protect-dos/directives-and-policy/learn-about-directives-and-policy/#arbitrator-fqdn-directive-app_protect_dos_arb_fqdn). | *svc-appprotect-dos-arb* |  |
{{</bootstrap-table>}}
