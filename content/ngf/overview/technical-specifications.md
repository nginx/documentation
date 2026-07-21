---
title: Technical specifications
description: NGINX Gateway Fabric technical specifications.
toc: true
weight: 300
f5-content-type: reference
f5-product: NGINX Gateway Fabric
f5-docs: DOCS-1842
---

This page describes the technical specifications for NGINX Gateway Fabric.

The information included covers version compatibility between NGINX Gateway Fabric and the Gateway API, as well as other NGINX products.

## NGINX Gateway Fabric versions

The following table lists the software versions NGINX Gateway Fabric supports. Only the latest patch release for each minor version is shown.

| NGINX Gateway Fabric | Gateway API | Kubernetes | NGINX OSS | NGINX Plus | NGINX Agent | F5 WAF for NGINX |
|----------------------|-------------|------------|-----------|------------|-------------|------------------|
| Edge                 | 1.5.1       | 1.31+      | 1.31.3    | R37.0      | v3.11.2     | 5.13.2           |
| 2.6.7                | 1.5.1       | 1.31+      | 1.31.3    | R37.0      | v3.11.2     | 5.13.2           |
| 2.5.1                | 1.5.1       | 1.31+      | 1.29.7    | R36        | v3.8.0      | ---              |
| 2.4.2                | 1.4.1       | 1.25+      | 1.29.5    | R36        | v3.7.1      | ---              |
| 2.3.0                | 1.4.1       | 1.25+      | 1.29.3    | R36        | v3.6.0      | ---              |
| 2.2.2                | 1.3.0       | 1.25+      | 1.29.2    | R35        | v3.6.0      | ---              |
| 2.1.4                | 1.3.0       | 1.25+      | 1.29.1    | R35        | v3.3.1      | ---              |
| 2.0.2                | 1.3.0       | 1.25+      | 1.28.0    | R34        | v3.0.1      | ---              |
| 1.6.2                | 1.2.1       | 1.25+      | 1.27.4    | R33        | ---         | ---              |
| 1.5.1                | 1.2.0       | 1.25+      | 1.27.2    | R33        | ---         | ---              |
| 1.4.0                | 1.1.0       | 1.25+      | 1.27.1    | R32        | ---         | ---              |
| 1.3.0                | 1.1.0       | 1.25+      | 1.27.0    | R32        | ---         | ---              |
| 1.2.0                | 1.0.0       | 1.23+      | 1.25.4    | R31        | ---         | ---              |

### OpenShift Compatibility

The following table lists the OpenShift versions and Operator versions compatible with NGINX Gateway Fabric.

| NGINX Gateway Fabric | Operator | Preferred Gateway API | Compatible Gateway API | OCP with Preferred GWAPI | Supported OCP Versions |
|----------------------|----------|-----------------------|------------------------|--------------------------|------------------------|
| 2.6.x                | v1.4.x   | v1.5.x                | v1.2.1-v1.5.x          | ---                      | 4.19 - 4.21            |
| 2.5.x                | v1.3.x   | v1.5.x                | v1.2.1-v1.5.x          | ---                      | 4.19 - 4.21            |
| 2.4.x                | v1.2.x   | v1.4.x                | v1.2.1-v1.4.x          | 4.20 & 4.21              | 4.19 - 4.21            |
| 2.2.x                | v1.0.x   | v1.3.0                | v1.2.1                 | ---                      | 4.19                   |

NGINX Gateway Fabric is conformant with the Gateway API version installed on supported OCP versions. The "OCP with Preferred GWAPI" column shows which OCP versions ship with the preferred Gateway API version. On OCP versions with an older Gateway API installed, NGF remains fully conformant with that installed version, but features from newer Gateway API versions that NGF supports will be unavailable.

## Supported container images

NGINX Gateway Fabric provides container images for the control plane and the NGINX data plane. All images are available for `amd64` and `arm64` architectures unless otherwise noted.

### Control plane images

The control plane image contains the NGINX Gateway Fabric binary.

| Name            | Base image            | Image                                                        | Architectures  |
|-----------------|-----------------------|--------------------------------------------------------------|----------------|
| Default image   | `scratch`             | `ghcr.io/nginx/nginx-gateway-fabric:{{< version-ngf >}}`     | amd64<br>arm64 |
| UBI-based image | `redhat/ubi9-minimal` | `ghcr.io/nginx/nginx-gateway-fabric:{{< version-ngf >}}-ubi` | amd64<br>arm64 |

### Data plane images with NGINX

| Name            | Base image            | Image                                                              | Architectures |
|-----------------|-----------------------|--------------------------------------------------------------------|----------------|
| Default image   | `alpine:3.23`         | `ghcr.io/nginx/nginx-gateway-fabric/nginx:{{< version-ngf >}}`     | amd64<br>arm64 |
| UBI-based image | `redhat/ubi9-minimal` | `ghcr.io/nginx/nginx-gateway-fabric/nginx:{{< version-ngf >}}-ubi` | amd64<br>arm64 |
 
### Data plane images with NGINX Plus

NGINX Plus images are available through the F5 Container registry `private-registry.nginx.com`. For setup instructions and authentication details, see [Install NGINX Gateway Fabric with NGINX Plus]({{< ref "/ngf/install/nginx-plus.md" >}}).

| Name                                  | Base image            | Image                                                                                      | Architectures  |
|---------------------------------------|-----------------------|--------------------------------------------------------------------------------------------|----------------|
| Default image                         | `alpine:3.22`         | `private-registry.nginx.com/nginx-gateway-fabric/nginx-plus:{{< version-ngf >}}`           | amd64<br>arm64 |
| UBI-based image                       | `redhat/ubi9-minimal` | `private-registry.nginx.com/nginx-gateway-fabric/nginx-plus:{{< version-ngf >}}-ubi`       | amd64<br>arm64 |
| Default image with F5 WAF for NGINX   | `alpine:3.22`         | `private-registry.nginx.com/nginx-gateway-fabric/nginx-plus-f5waf:{{< version-ngf >}}`     | amd64          |
| UBI-based image with F5 WAF for NGINX | `redhat/ubi9-minimal` | `private-registry.nginx.com/nginx-gateway-fabric/nginx-plus-f5waf:{{< version-ngf >}}-ubi` | amd64          |

### WAF sidecar images

When F5 WAF for NGINX is enabled, two additional sidecar containers are deployed alongside the NGINX container. These images are available from the F5 Container registry.

| Name | Image | Architectures |
|--------------------|---------------------------------------------------------------------------------|-------|
| WAF Enforcer       | `private-registry.nginx.com/nap/waf-enforcer:{{< ngf-waf-release-version >}}`   | amd64 |
| WAF Config Manager | `private-registry.nginx.com/nap/waf-config-mgr:{{< ngf-waf-release-version >}}` | amd64 |

For more information on WAF integration, see [F5 WAF for NGINX overview]({{< ref "/ngf/waf-integration/overview.md" >}}).

### Custom images

You can build custom NGINX Gateway Fabric images from source. For instructions, see [Build NGINX Gateway Fabric]({{< ref "/ngf/install/build-image.md" >}}).

---

## Gateway API compatibility

The following tables summarizes which Gateway API resources NGINX Gateway Fabric supports and to which level.

You can read more information by viewing the [Gateway API compatibility]({{< ref "/ngf/overview/gateway-api-compatibility.md" >}}) topic, or by selecting the resource name to go directly to the full details.

{{< include "ngf/gateway-api-compat-table.md" >}}