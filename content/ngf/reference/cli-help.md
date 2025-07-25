---
title: Command-line reference guide
weight: 100
toc: true
type: reference
product: NGF
nd-docs: DOCS-1843
---

## Overview

Learn about the commands available for the executable file of the NGINX Gateway Fabric container.

---

## Controller

This command runs the NGINX Gateway Fabric control plane.

*Usage*:

```shell
  gateway controller [flags]
```

---

### Flags

{{< bootstrap-table "table table-bordered table-striped table-responsive" >}}

| Name                                | Type     | Description                                                                                                                                                                                                                                                                                                                                                                              |
|-------------------------------------|----------|------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| _gateway-ctlr-name_                 | _string_ | The name of the Gateway controller. The controller name must be in the form: `DOMAIN/PATH`. The controller's domain is `gateway.nginx.org`.                                                                                                                                                                                                                                              |
| _gatewayclass_                      | _string_ | The name of the GatewayClass resource. Every NGINX Gateway Fabric must have a unique corresponding GatewayClass resource.                                                                                                                                                                                                                                                                |
| _nginx-plus_                        | _bool_   | Enable support for NGINX Plus.                                                                                                                                                                                                                                                                                                                                                           |
| _gateway-api-experimental-features_ | _bool_   | Enable the experimental features of Gateway API which are supported by NGINX Gateway Fabric. Requires the Gateway APIs installed from the experimental channel.                                                                                                                                                                                                                          |
| _config_                            | _string_ | The name of the NginxGateway resource to be used for this controller's dynamic configuration. Lives in the same namespace as the controller.                                                                                                                                                                                                                                             |
| _service_                           | _string_ | The name of the service that fronts this NGINX Gateway Fabric pod. Lives in the same namespace as the controller.                                                                                                                                                                                                                                                                        |
| _metrics-disable_                   | _bool_   | Disable exposing metrics in the Prometheus format (Default: `false`).                                                                                                                                                                                                                                                                                                                    |
| _metrics-listen-port_               | _int_    | Sets the port where the Prometheus metrics are exposed. An integer between 1024 - 65535 (Default: `9113`)                                                                                                                                                                                                                                                                                |
| _metrics-secure-serving_            | _bool_   | Configures if the metrics endpoint should be secured using https. Note that this endpoint will be secured with a self-signed certificate (Default `false`).                                                                                                                                                                                                                              |
| _health-disable_                    | _bool_   | Disable running the health probe server (Default: `false`).                                                                                                                                                                                                                                                                                                                              |
| _health-port_                       | _int_    | Set the port where the health probe server is exposed. An integer between 1024 - 65535 (Default: `8081`).                                                                                                                                                                                                                                                                                |
| _leader-election-disable_           | _bool_   | Disable leader election, which is used to avoid multiple replicas of the NGINX Gateway Fabric reporting the status of the Gateway API resources. If disabled, all replicas of NGINX Gateway Fabric will update the statuses of the Gateway API resources (Default: `false`).                                                                                                             |
| _leader-election-lock-name_         | _string_ | The name of the leader election lock. A lease object with this name will be created in the same namespace as the controller (Default: `"nginx-gateway-leader-election-lock"`).                                                                                                                                                                                                           |
| _product-telemetry-disable_         | _bool_   | Disable the collection of product telemetry (Default: `false`).                                                                                                                                                                                                                                                                                                                          |
| _nginx-docker-secret_               | _list_   | The name of the NGINX docker registry Secret(s). Must exist in the same namespace that the NGINX Gateway Fabric control plane is running in (default namespace: nginx-gateway). |
| _usage-report-secret_               | _string_ | The name of the Secret containing the JWT for NGINX Plus usage reporting. Must exist in the same namespace that the NGINX Gateway Fabric control plane is running in (default namespace: nginx-gateway)                                                                                                                                                                                                                                                                                              |
| _usage-report-endpoint_           | _string_ | The endpoint of the NGINX Plus usage reporting server.                                                                                                                                                                                                                                                                                                                            |
| _usage-report-resolver_         | _string_ | The nameserver used to resolve the NGINX Plus usage reporting endpoint. Used with NGINX Instance Manager.                                                                                                                                                                                                                                                                                                     |
| _usage-report-skip-verify_          | _bool_   | Disable client verification of the NGINX Plus usage reporting server certificate.                                                                                                                                                                                                                                                                                                        |
| _usage-report-ca-secret_               | _string_ | The name of the Secret containing the NGINX Instance Manager CA certificate. Must exist in the same namespace that the NGINX Gateway Fabric control plane is running in (default namespace: nginx-gateway)                                                                                                                                                                                                                                                                                              |
| _usage-report-client-ssl-secret_               | _string_ | TThe name of the Secret containing the client certificate and key for authenticating with NGINX Instance Manager. Must exist in the same namespace that the NGINX Gateway Fabric control plane is running in (default namespace: nginx-gateway)                                                                                                                                                                                                                                                                                              |
| _snippets-filters_                  | _bool_   | Enable SnippetsFilters feature. SnippetsFilters allow inserting NGINX configuration into the generated NGINX config for HTTPRoute and GRPCRoute resources.                                                                                                                                                                                                                               |
| _nginx-scc_                  | _string_   | The name of the SecurityContextConstraints to be used with the NGINX data plane Pods. Only applicable in OpenShift.                                                                                                                                                                                                                               |

{{% /bootstrap-table %}}

---

## Sleep

This command sleeps for specified duration, then exits.

_Usage_:

```shell
  gateway sleep [flags]
```

{{< bootstrap-table "table table-bordered table-striped table-responsive" >}}

| Name     | Type            | Description                                                                                                                   |
| -------- | --------------- | ----------------------------------------------------------------------------------------------------------------------------- |
| duration | `time.Duration` | Set the duration of sleep. Must be parsable by [`time.ParseDuration`](https://pkg.go.dev/time#ParseDuration). (default `30s`) |

{{% /bootstrap-table %}}
