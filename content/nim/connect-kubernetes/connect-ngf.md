---
title: Connect NGINX Gateway Fabric to NGINX Instance Manager
weight: 100
toc: true
f5-content-type: how-to
f5-product: NGINX Instance Manager
f5-docs: 
description: "Connect NGINX Gateway Fabric to F5 NGINX Instance Manager to export F5 WAF security events to the Security Dashboard."
f5-summary: >
  Connect NGINX Gateway Fabric to F5 NGINX Instance Manager to export F5 WAF security events to the Security Dashboard.
  This page covers the NGINX Plus JWT, the NGINX Plus Secret, and the Helm values required to configure the connection.
---

## Overview

Connect NGINX Gateway Fabric to NGINX Instance Manager to export F5 WAF security events to the Security Dashboard.

This connection supports security event export only. F5 WAF policy fetching uses a separate credential flow. See [Configure policy sources]({{< ref "/ngf/waf-integration/policy-sources.md" >}}).

---

## Before you begin

Before you begin, verify that you have:

- Administrator access to a Kubernetes cluster
- Helm and kubectl installed locally
- An NGINX Plus subscription

---

## Download your NGINX Plus JWT

{{< include "/ngf/installation/nginx-plus/download-jwt.md" >}}

---

## Create the NGINX Plus Secret

{{< include "/ngf/installation/nginx-plus/nginx-plus-secret.md" >}}

This Secret is required to run NGINX Plus, with or without F5 WAF for NGINX. It also authenticates the connection from NGINX Gateway Fabric to NGINX Instance Manager.

---

## Install Gateway API resources

{{< include "/ngf/installation/install-gateway-api-resources.md" >}}

---

## Install NGINX Gateway Fabric

This integration requires NGINX Plus with F5 WAF for NGINX. Install NGINX Gateway Fabric using the following Helm command:

```shell
helm install ngf oci://ghcr.io/nginx/charts/nginx-gateway-fabric \
  --set nginx.image.repository=private-registry.nginx.com/nginx-gateway-fabric/nginx-plus \
  --set nginx.plus=true \
  --set nginx.config.waf.enable=true \
  --set nginx.imagePullSecret=nginx-plus-registry-secret \
  --set nginx.usage.secretName=nplus-license \
  --set nginx.nginxInstanceManager.endpointHost=<NIM_HOSTNAME> \
  -n nginx-gateway
```

Replace `<NIM_HOSTNAME>` with your NGINX Instance Manager hostname.

---

## See also

- [Deploy a Gateway for data plane instances]({{< ref "/ngf/install/deploy-data-plane.md" >}})
- [Configure policy sources]({{< ref "/ngf/waf-integration/policy-sources.md" >}})
- [View NGINX Gateway Fabric security events]({{< ref "/nim/security-monitoring/ngf-security-events.md" >}})