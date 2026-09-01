---
title: Connect NGINX Gateway Fabric to NGINX Instance Manager
weight: 100
toc: true
f5-content-type: how-to
f5-product: NGINX Instance Manager
f5-docs: 
description: "Connect NGINX Gateway Fabric to F5 NGINX Instance Manager to export F5 WAF security events to the Security Dashboard."
f5-summary: >
  Connect NGINX Gateway Fabric to F5 NGINX Instance Manager to set up the control plane connection NGINX Gateway Fabric uses to export F5 WAF security events to NGINX Instance Manager.
  This page covers the NGINX Plus JWT, the Secret for the NGINX Instance Manager dataplane key, and the Helm values needed to point NGINX Gateway Fabric at your NGINX Instance Manager deployment.
---

<!-- SME REVIEW — READ BEFORE PUBLISHING: this page documents connecting NGINX Gateway Fabric to NGINX Instance Manager using the dataplane key mechanism from PR #316. Confirmed purpose: this connection is required for NGINX Gateway Fabric to export F5 WAF security events (TECHDOCS-5505). Not confirmed: whether this same connection also enables other capabilities, such as F5 WAF policy fetching or general instance visibility, the way the equivalent N1C connection does (docs.nginx.com/nginx-one-console/k8s/add-ngf-helm/ states it "enables centralized monitoring of all controller instances"). Don't broaden this page's claims beyond security event export until that's confirmed with engineering. -->

## Overview

Connect NGINX Gateway Fabric to NGINX Instance Manager to set up the control plane connection required for NGINX Gateway Fabric to export F5 WAF security events to the NGINX Instance Manager Security Dashboard.

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

This Secret is required to run NGINX Plus, with or without F5 WAF for NGINX.

---

## Create the NGINX Instance Manager dataplane key Secret

<!-- SME REVIEW — PENDING CHANGE: Shaun indicated in PR #316 that this step may become unnecessary in a future update, where the existing nplus-license Secret is reused instead of a separate dataplane-key Secret ("Step 3 in this won't be necessary. We can actually use the nplus-license instead. I'll be pushing an update for that soon so can be part of the release."). Confirm with Shaun whether this step is still required before this page ships with the 2.23 release. If his update lands first, this section needs to be replaced, not just edited. -->

Rename your NGINX Plus JWT file to `dataplane.key`, then create a Secret from it:

```shell
cp license.jwt dataplane.key
kubectl create secret generic nim-dp-key --from-file=dataplane.key -n nginx-gateway
rm dataplane.key
```

This creates a Secret named `nim-dp-key` in the `nginx-gateway` namespace. The Secret contains your NGINX Plus JWT under the required `dataplane.key` filename. The Secret name and filename are fixed. NGINX Gateway Fabric expects the key to be named `dataplane.key` inside the Secret.

---

## Install Gateway API resources

{{< include "/ngf/installation/install-gateway-api-resources.md" >}}

---

## Install NGINX Gateway Fabric

<!-- SME REVIEW — PENDING CHANGE: this command references the nim-dp-key Secret from the previous step, which Shaun indicated may be replaced by reusing nplus-license directly. If that update lands, this command's --set nginx.nginxInstanceManager.dataplaneKeySecretName value changes too. Don't publish until step 3's status is confirmed. -->

This integration requires NGINX Plus with F5 WAF for NGINX. There is only one supported install path.

```shell
helm install ngf oci://ghcr.io/nginx/charts/nginx-gateway-fabric \
  --set nginx.image.repository=private-registry.nginx.com/nginx-gateway-fabric/nginx-plus \
  --set nginx.plus=true \
  --set nginx.config.waf.enable=true \
  --set nginx.imagePullSecret=nginx-plus-registry-secret \
  --set nginx.usage.secretName=nplus-license \
  --set nginx.nginxInstanceManager.dataplaneKeySecretName=nim-dp-key \
  --set nginx.nginxInstanceManager.endpointHost=<NIM_HOSTNAME> \
  -n nginx-gateway
```

Replace `<NIM_HOSTNAME>` with your NGINX Instance Manager hostname.

---

## See also

- [Deploy a Gateway for data plane instances]({{< ref "/ngf/install/deploy-data-plane.md" >}})
- [Configure policy sources]({{< ref "/ngf/waf-integration/policy-sources.md" >}})
- [View NGINX Gateway Fabric security events]({{< ref "/nim/security-monitoring/ngf-security-events.md" >}})