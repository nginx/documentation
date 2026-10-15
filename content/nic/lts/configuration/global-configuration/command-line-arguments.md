---
title: Command-line arguments
toc: true
weight: 100
f5-content-type: reference
f5-product: NGINX Ingress Controller
---

F5 NGINX Ingress Controller LTS supports several command-line arguments, which are set based on installation method:

- If you're using *Kubernetes Manifests* to install NGINX Ingress Controller LTS, modify the Manifests to set the command-line arguments. View the [Installation with Manifests]({{< ref "/nic/lts/install/manifests.md" >}}) topic for more information.
- If you're using *Helm* to install NGINX Ingress Controller LTS, modify the parameters of the Helm chart to set the command-line arguments. View the [Installation with Helm]({{< ref "/nic/lts/install/helm.md" >}}) topic for more information.

### -enable-snippets {#cmdoption-enable-snippets}

Enable custom NGINX configuration snippets in Ingress, VirtualServer, VirtualServerRoute and TransportServer resources.

Default `false`.

### -default-server-tls-secret <string> {#cmdoption-default-server-tls-secret}

Secret with a TLS certificate and key for TLS termination of the default server.

- If not set, certificate and key in the file `/etc/nginx/secrets/default` are used.
- If `/etc/nginx/secrets/default` doesn't exist, NGINX Ingress Controller LTS will configure NGINX to reject TLS connections to the default server.
- If a secret is set, but NGINX Ingress Controller LTS is not able to fetch it from Kubernetes API, or it is not set and NGINX Ingress Controller LTS fails to read the file "/etc/nginx/secrets/default", NGINX Ingress Controller LTS will fail to start.

Format: `<NAMESPACE>/<NAME>`

### -wildcard-tls-secret <string> {#cmdoption-wildcard-tls-secret}

A Secret with a TLS certificate and key for TLS termination of every Ingress/VirtualServer host for which TLS termination is enabled but the Secret is not specified.

- If the argument is not set, for such Ingress/VirtualServer hosts NGINX will break any attempt to establish a TLS connection
- If the argument is set, but NGINX Ingress Controller LTS is not able to fetch the Secret from Kubernetes API, NGINX Ingress Controller LTS will fail to start.

Format: `<NAMESPACE>/<NAME>`

### -enable-custom-resources {#cmdoption-enable-custom-resources}

Enables custom resources.

Default `true`.

### -enable-oidc {#cmdoption-enable-oidc}

Enables OIDC policies.

Default `false`.

### -enable-leader-election {#cmdoption-enable-leader-election}

Enables Leader election to avoid multiple replicas of the controller reporting the status of Ingress, VirtualServer and VirtualServerRoute resources -- only one replica will report status.
Default `true`.

See [-report-ingress-status](#cmdoption-report-ingress-status) flag.

### -enable-tls-passthrough {#cmdoption-enable-tls-passthrough}

Enable TLS Passthrough on port 443.

Requires [-enable-custom-resources](#cmdoption-enable-custom-resources).

### -tls-passthrough-port <int> {#cmdoption-tls-passthrough-port}

Set the port for TLS Passthrough.
Format: `[1024 - 65535]` (default `443`)

Requires [-enable-custom-resources](#cmdoption-enable-custom-resources).

### -enable-cert-manager {#cmdoption-enable-cert-manager}

Enable x509 automated certificate management for VirtualServer resources using cert-manager (cert-manager.io).

Requires [-enable-custom-resources](#cmdoption-enable-custom-resources).

### -enable-external-dns {#cmdoption-enable-external-dns}

Enable integration with ExternalDNS for configuring public DNS entries for VirtualServer resources using [ExternalDNS](https://github.com/kubernetes-sigs/external-dns).

Requires [-enable-custom-resources](#cmdoption-enable-custom-resources).

### -external-service <string> {#cmdoption-external-service}

Specifies the name of the service with the type LoadBalancer through which the NGINX Ingress Controller LTS pods are exposed externally. The external address of the service is used when reporting the status of Ingress, VirtualServer and VirtualServerRoute resources.

For Ingress resources only: Requires [-report-ingress-status](#cmdoption-report-ingress-status).

### -ingresslink <string> {#cmdoption-ingresslink}

Specifies the name of the IngressLink resource, which exposes the NGINX Ingress Controller LTS pods via a BIG-IP system. The IP of the BIG-IP system is used when reporting the status of Ingress, VirtualServer and VirtualServerRoute resources.

For Ingress resources only: Requires [-report-ingress-status](#cmdoption-report-ingress-status).

### -global-configuration <string> {#cmdoption-global-configuration}

A GlobalConfiguration resource for global configuration of NGINX Ingress Controller LTS.

Format: `<NAMESPACE>/<NAME>`

Requires [-enable-custom-resources](#cmdoption-enable-custom-resources).

### -health-status {#cmdoption-health-status}

Adds a location "/nginx-health" to the default server. The location responds with the 200 status code for any request.

Useful for external health-checking of NGINX Ingress Controller LTS.

### -health-status-uri <string> {#cmdoption-health-status-uri}

Sets the URI of health status location in the default server. Requires [-health-status](#cmdoption-health-status). (default `/nginx-health`)

### -ingress-class <string> {#cmdoption-ingress-class}

The `-ingress-class` argument refers to the name of the resource `kind: IngressClass`. An IngressClass resource with a name equal to the class must be deployed. Otherwise, NGINX Ingress Controller LTS will fail to start.
NGINX Ingress Controller LTS will only process Ingress resources that belong to its class (Whose `ingressClassName` value matches the value of `-ingress-class`), skipping the ones without it. It will also process all the VirtualServer/VirtualServerRoute/TransportServer resources that do not have the `ingressClassName` field.

Default `nginx`.

### -ingress-template-path <string> {#cmdoption-ingress-template-path}

Path to the ingress NGINX configuration template for an ingress resource. Default: `nginx-plus.ingress.tmpl`.

### -leader-election-lock-name <string> {#cmdoption-leader-election-lock-name}

Specifies the name of the ConfigMap, within the same namespace as the controller, used as the lock for leader election.

Requires [-enable-leader-election](#cmdoption-enable-leader-election).

### -log_backtrace_at <value> {#cmdoption-log_backtrace_at}

When logging hits line `file:N`, emit a stack trace.

### -main-template-path <string> {#cmdoption-main-template-path}

Path to the main NGINX configuration template.

- Default: `nginx-plus.tmpl`.

### -nginx-configmaps <string> {#cmdoption-nginx-configmaps}

A ConfigMap resource for customizing NGINX configuration. If a ConfigMap is set, but NGINX Ingress Controller LTS is not able to fetch it from Kubernetes API, NGINX Ingress Controller LTS will fail to start.

Format: `<NAMESPACE>/<NAME>`

### -mgmt-configmap <string> {#cmdoption-mgmt-configmap}

The Management ConfigMap resource is used for customizing the NGINX mgmt block. If using NGINX Plus, a Management ConfigMap must be set. If NGINX Ingress Controller LTS is not able to fetch it from Kubernetes API, NGINX Ingress Controller LTS will fail to start.

Format: `<NAMESPACE>/<NAME>`

### -nginx-debug {#cmdoption-nginx-debug}

Enable debugging for NGINX. Uses the nginx-debug binary. Requires 'error-log-level: debug' in the ConfigMap.

### -nginx-plus {#cmdoption-nginx-plus}

Enable support for NGINX Plus.

### -nginx-reload-timeout <value> {#cmdoption-nginx-reload-timeout}

Timeout in milliseconds which NGINX Ingress Controller LTS will wait for a successful NGINX reload after a change or at the initial start.

Default is 60000.

### -nginx-status {#cmdoption-nginx-status}

Enable the NGINX Plus API.

Default `true`.

### -nginx-status-allow-cidrs <string> {#cmdoption-nginx-status-allow-cidrs}

Add IP/CIDR blocks to the allow list for the NGINX Plus API.

Separate multiple IP/CIDR by commas. (default `127.0.0.1,::1`)

### -nginx-status-port <int> {#cmdoption-nginx-status-port}

Set the port where the NGINX Plus API is exposed.

Format: `[1024 - 65535]` (default `8080`)

### -proxy <string> {#cmdoption-proxy}

{{< call-out "warning" >}} This argument is intended for testing purposes only. {{< /call-out >}}

Use a proxy server to connect to Kubernetes API started with `kubectl proxy`.

NGINX Ingress Controller LTS does not start NGINX and does not write any generated NGINX configuration files to disk.

### -report-ingress-status {#cmdoption-report-ingress-status}

Updates the address field in the status of Ingress resources.

Requires the [-external-service](#cmdoption-external-service) or [-ingresslink](#cmdoption-ingresslink) flag, or the `external-status-address` key in the ConfigMap.

### -transportserver-template-path <string> {#cmdoption-transportserver-template-path}

Path to the TransportServer NGINX configuration template for a TransportServer resource.

- Default: `nginx-plus.transportserver.tmpl`.

### -log-level <string> {#cmdoption-log-level}

Log level for Ingress Controller logs. Allowed values: fatal, error, warn, info, debug, trace.

- Default is `info`.

### -log-format <string> {#cmdoption-log-format}

Log format for Ingress Controller logs. Allowed values: glog, json, text.

- Default is `glog`.

### -version {#cmdoption-version}

Print the version, git-commit hash and build date and exit.

### -virtualserver-template-path <string> {#cmdoption-virtualserver-template-path}

Path to the VirtualServer NGINX configuration template for a VirtualServer resource.

- Default: `nginx-plus.virtualserver.tmpl`.

### -vmodule <value> {#cmdoption-vmodule}

A comma-separated list of pattern=N settings for file-filtered logging.

### -watch-namespace <string> {#cmdoption-watch-namespace}

Comma separated list of namespaces NGINX Ingress Controller LTS should watch for resources. By default NGINX Ingress Controller LTS watches all namespaces. Mutually exclusive with "watch-namespace-label".

### -watch-namespace-label <string> {#cmdoption-watch-namespace-label}

Configures NGINX Ingress Controller LTS to watch only those namespaces with label foo=bar. By default NGINX Ingress Controller LTS watches all namespaces. Mutually exclusive with "watch-namespace".

### -watch-secret-namespace <string> {#cmdoption-watch-secret-namespace}

Comma separated list of namespaces NGINX Ingress Controller LTS should watch for secrets. If this arg is not configured, NGINX Ingress Controller LTS watches the same namespaces for all resources, see "watch-namespace" and "watch-namespace-label". All namespaces included with this argument must be part of either `-watch-namespace` or  `-watch-namespace-label`.

### -enable-prometheus-metrics {#cmdoption-enable-prometheus-metrics}

Enables exposing NGINX Plus metrics in the Prometheus format.

### -prometheus-metrics-listen-port <int> {#cmdoption-prometheus-metrics-listen-port}

Sets the port where the Prometheus metrics are exposed.

Format: `[1024 - 65535]` (default `9113`)

### -prometheus-tls-secret <string> {#cmdoption-prometheus-tls-secret}

A Secret with a TLS certificate and key for TLS termination of the Prometheus metrics endpoint.

- If the argument is not set, the Prometheus endpoint will not use a TLS connection.
- If the argument is set, but NGINX Ingress Controller LTS is not able to fetch the Secret from Kubernetes API, NGINX Ingress Controller LTS will fail to start.

### -enable-service-insight {#cmdoption-enable-service-insight}

Exposes the Service Insight endpoint for Ingress Controller.

### -service-insight-listen-port <int> {#cmdoption-service-insight-listen-port}

Sets the port where the Service Insight is exposed.

Format: `[1024 - 65535]` (default `9114`)

### -service-insight-tls-secret <string> {#cmdoption-service-insight-tls-secret}

A Secret with a TLS certificate and key for TLS termination of the Service Insight endpoint.

- If the argument is not set, the Service Insight endpoint will not use a TLS connection.
- If the argument is set, but NGINX Ingress Controller LTS is not able to fetch the Secret from Kubernetes API, NGINX Ingress Controller LTS will fail to start.

Format: `<NAMESPACE>/<NAME>`

### -spire-agent-address <string> {#cmdoption-spire-agent-address}

Specifies the address of a running Spire agent. **For use with NGINX Service Mesh only**.

- If the argument is set, but NGINX Ingress Controller LTS is unable to connect to the Spire Agent, NGINX Ingress Controller LTS will fail to start.

### -enable-internal-routes {#cmdoption-enable-internal-routes}

Enable support for internal routes with NGINX Service Mesh. **For use with NGINX Service Mesh only**.

Requires [-spire-agent-address](#cmdoption-spire-agent-address).

- If the argument is set, but `spire-agent-address` is not provided, NGINX Ingress Controller LTS will fail to start.

### -enable-latency-metrics {#cmdoption-enable-latency-metrics}

Enable collection of latency metrics for upstreams.
Requires [-enable-prometheus-metrics](#cmdoption-enable-prometheus-metrics).

### -ready-status {#cmdoption-ready-status}

Enables the readiness endpoint `/nginx-ready`. The endpoint returns a success code when NGINX has loaded all the config after the startup.

Default `true`.

### -ready-status-port {#cmdoption-ready-status-port}

The HTTP port for the readiness endpoint.

Format: `[1024 - 65535]` (default `8081`)

### -disable-ipv6 {#cmdoption-disable-ipv6}

Disable IPV6 listeners explicitly for nodes that do not support the IPV6 stack.

Default `false`.

### -default-http-listener-port {#cmdoption-default-http-listener-port}

Sets the port for the HTTP `default_server` listener.

Default `80`.

### -default-https-listener-port {#cmdoption-default-https-listener-port}

Sets the port for the HTTPS `default_server` listener.

Default `443`.

### -ssl-dynamic-reload {#cmdoption-ssl-dynamic-reload}

Used to activate or deactivate lazy loading for SSL Certificates.

The default value is `true`.

### -weight-changes-dynamic-reload {#cmdoption-weight-changes-dynamic-reload}

Enables the ability to change the weight distribution of two-way split clients without reloading NGINX.

Requires [-nginx-plus](#cmdoption-nginx-plus).

Using this feature may require increasing `map_hash_bucket_size`, `map_hash_max_size`, `variable_hash_bucket_size`, and `variable_hash_max_size` in the ConfigMap based on the number of two-way splits.

The default value is `false`.

- If the argument is set, but `nginx-plus` is set to false, NGINX Ingress Controller LTS will ignore the flag.

### -enable-directive-autoadjust {#cmdoption-enable-directive-autoadjust}

Automatically adjusts NGINX buffer directives to prevent configuration errors.

The default value is `false`.

When enabled, the controller automatically adjusts `proxy_buffers`, `proxy_buffer_size`, and `proxy_busy_buffers_size` to ensure they work together properly and NGINX can start successfully.

More explanation about this feature can be found in the guide [here]({{< ref "/nic/lts/configuration/proxy-buffers-configuration.md" >}}).

### -enable-telemetry-reporting {#cmdoption-enable-telemetry-reporting}

Enable gathering and reporting of software telemetry.

The default value is `true`.
