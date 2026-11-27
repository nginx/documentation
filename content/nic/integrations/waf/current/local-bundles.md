---
title: Use local policy bundles with F5 WAF for NGINX
linkTitle: "Local bundles"
description: Compile an F5 WAF for NGINX policy bundle, copy it to the bundle folder, and reference it from an NGINX Ingress Controller Policy resource.
weight: 400
toc: true
f5-content-type: how-to
f5-product: F5 NGINX Ingress Controller
aliases:
  - /nginx-ingress-controller/integrations/app-protect-waf-v5/configuration/
---

**Applies to:** Current F5 WAF for NGINX integration, bundle-based (local bundles)

## Overview

This document explains how to use [F5 WAF for NGINX]({{< ref "/waf/" >}}) with local policy bundles in F5 NGINX Ingress Controller. You copy compiled bundles to the bundle folder, `/etc/app_protect/bundles`, and reference them from a Policy resource.

{{< call-out class="note" >}} There are complete NGINX Ingress Controller with F5 WAF for NGINX [example resources on GitHub](https://github.com/nginx/kubernetes-ingress/tree/v{{< nic-version >}}/examples/custom-resources/app-protect-waf-v5). {{< /call-out >}}

## Global configuration

NGINX Ingress Controller has global configuration parameters that match those in F5 WAF for NGINX. They are found in the [ConfigMap resource]({{< ref "/nic/configuration/global-configuration/configmap-resource.md#modules" >}}): the F5 WAF for NGINX parameters are prefixed with `app-protect*`.

## Turn on F5 WAF for NGINX

You turn on F5 WAF for NGINX for VirtualServer, VirtualServerRoute, and Ingress resources with an NGINX Ingress Controller Policy resource. The Policy resource references a local bundle, a bundle source, or, with Policy Lifecycle Management (PLM), an `APPolicy` resource. Additional detail can be found in the [Policy Resource documentation]({{< ref "/nic/configuration/policy-resource/policy-reference.md#waf" >}}).

{{< call-out class="note" >}}

Some policies use NGINX subrequests: `APIKey`, `ExternalAuth`, `JWT` with `jwksURI`, `OIDC`, and `OIDCNative`. NGINX Ingress Controller turns off F5 WAF for NGINX in the internal locations that serve these subrequests. As a result, you can apply these policies and F5 WAF for NGINX to the same route. F5 WAF for NGINX continues to inspect client requests to the route.

A `Cache` policy with `cacheBackgroundUpdate` also uses subrequests. These subrequests may not work as expected when F5 WAF for NGINX applies to the same route.

{{< /call-out >}}

---

## Add policy bundles to the bundle folder

F5 WAF for NGINX bundles for VirtualServer custom resources are defined by creating policy bundles and putting them on a mounted volume accessible from NGINX Ingress Controller.

Before applying a policy, a policy bundle must be created, then copied to a volume mounted to `/etc/app_protect/bundles`. This is the bundle folder for the current F5 WAF for NGINX integration. The legacy F5 WAF for NGINX integration uses a different folder, so check [which integration you run]({{< ref "/nic/integrations/waf/choose-deployment.md#check-which-integration-you-run" >}}) before you copy bundles.

To compile a policy bundle, use the [F5 WAF for NGINX compiler]({{< ref "/waf/configure/compiler.md" >}}), as shown in [Install F5 WAF for NGINX with Helm and local bundles]({{< ref "/nic/integrations/waf/current/helm-local-bundles.md" >}}). You can also [compile policy bundles with NGINX Instance Manager]({{< ref "/nic/integrations/waf/current/compile-waf-policies.md" >}}).

{{< call-out class="tip" >}} Instead of manually placing bundles on a mounted volume, you can configure NGINX Ingress Controller to fetch bundles from a remote source automatically. See [Fetch policy bundles from a remote source]({{< ref "/nic/integrations/waf/current/bundle-sources.md" >}}) for details on NGINX One Console, NGINX Instance Manager, and HTTPS source types. {{< /call-out >}}

{{< call-out class="note" >}} NGINX Ingress Controller supports `securityLogs` for policy bundles. Log bundles must also be copied to a volume mounted to `/etc/app_protect/bundles`. {{< /call-out >}}

This example shows an NGINX Ingress Controller Policy resource that references a local policy bundle:

```yaml
apiVersion: k8s.nginx.org/v1
kind: Policy
metadata:
  name: <POLICY_NAME>
spec:
  waf:
    enable: true
    apBundle: "<POLICY_BUNDLE_NAME>.tgz"
```

Replace `<POLICY_NAME>` with the name of your policy and `<POLICY_BUNDLE_NAME>` with the name of your policy bundle.

This example shows the same policy as above but with a log bundle used for security log configuration:

```yaml
apiVersion: k8s.nginx.org/v1
kind: Policy
metadata:
  name: <POLICY_NAME>
spec:
  waf:
    enable: true
    apBundle: "<POLICY_BUNDLE_NAME>.tgz"
    securityLogs:
    - enable: true
      apLogBundle: "<LOG_BUNDLE_NAME>.tgz"
      logDest: "syslog:server=syslog-svc.default:514"
```

Replace `<LOG_BUNDLE_NAME>` with the name of your log bundle.

---

## Configure NGINX Plus Ingress Controller using Virtual Server resources

This example shows how to deploy NGINX Ingress Controller with NGINX Plus and F5 WAF for NGINX, deploy a simple web application, and then configure load balancing and WAF protection for that application using the VirtualServer resource.

{{< call-out class="note" >}} You can find the files for this example on [GitHub](https://github.com/nginx/kubernetes-ingress/tree/v{{< nic-version >}}/examples/custom-resources/app-protect-waf-v5).{{< /call-out >}}

### Prerequisites

1. Follow the installation [instructions]({{< ref "/nic/integrations/waf/current/installation.md" >}}) to deploy NGINX Ingress Controller with NGINX Plus and F5 WAF for NGINX.

2. Save the public IP address of NGINX Ingress Controller into a shell variable:

   ```shell
    IC_IP=XXX.YYY.ZZZ.III
   ```

3. Save the HTTP port of NGINX Ingress Controller into a shell variable:

   ```shell
    IC_HTTP_PORT=<PORT_NUMBER>
   ```

   Replace `<PORT_NUMBER>` with the port number to use.

### Deploy a web application

Create the application deployment and service:

  ```shell
  kubectl apply -f https://raw.githubusercontent.com/nginx/kubernetes-ingress/v{{< nic-version >}}/examples/custom-resources/app-protect-waf-v5/webapp.yaml
  ```

### Create the Syslog service

Create the syslog service and pod for the F5 WAF for NGINX security logs:

   ```shell
   kubectl apply -f https://raw.githubusercontent.com/nginx/kubernetes-ingress/v{{< nic-version >}}/examples/custom-resources/app-protect-waf-v5/syslog.yaml
   ```

### Deploy the Policy resource

{{< call-out class="note" >}} Configuration settings in the Policy resource enable WAF protection by configuring F5 WAF for NGINX with the log configuration created in the previous step. The policy bundle referenced as `your_policy_bundle_name.tgz` needs to be created and placed in the `/etc/app_protect/bundles` volume first.{{< /call-out >}}

Create and deploy the Policy resource.

 ```shell
  kubectl apply -f https://raw.githubusercontent.com/nginx/kubernetes-ingress/v{{< nic-version >}}/examples/custom-resources/app-protect-waf-v5/waf.yaml
 ```

### Configure load balancing

{{< call-out class="note" >}} VirtualServer references the `waf-policy` created in Step 3.{{< /call-out >}}

1. Create the VirtualServer Resource:

    ```shell
    kubectl apply -f https://raw.githubusercontent.com/nginx/kubernetes-ingress/v{{< nic-version >}}/examples/custom-resources/app-protect-waf-v5/virtual-server.yaml
    ```

### Test the application

To access the application, curl the coffee and the tea services. Use the `--resolve` option to set the Host header of a request with `webapp.example.com`

1. Send a request to the application:

  ```shell
  curl --resolve webapp.example.com:$IC_HTTP_PORT:$IC_IP http://webapp.example.com:$IC_HTTP_PORT/
  ```

  ```shell
  Server address: 10.12.0.18:80
  Server name: webapp-7586895968-r26zn
  ```

1. Try to send a request with a suspicious URL:

  ```shell
  curl --resolve webapp.example.com:$IC_HTTP_PORT:$IC_IP "http://webapp.example.com:$IC_HTTP_PORT/<script>"
  ```

  ```shell
  <html><head><title>Request Rejected</title></head><body>
  ```

1.  Check the security logs in the syslog pod:

  ```shell
  kubectl exec -it <SYSLOG_POD> -- cat /var/log/messages
  ```

  Replace `<SYSLOG_POD>` with the name of your syslog pod.

## Example VirtualServer configuration

The GitHub repository has a full [VirtualServer example](https://raw.githubusercontent.com/nginx/kubernetes-ingress/v{{< nic-version >}}/examples/custom-resources/app-protect-waf-v5/webapp.yaml).

```yaml
apiVersion: k8s.nginx.org/v1
kind: VirtualServer
metadata:
  name: webapp
spec:
  host: webapp.example.com
  policies:
  - name: waf-policy
  upstreams:
  - name: webapp
    service: webapp-svc
    port: 80
  routes:
  - path: /
    action:
      pass: webapp
```
