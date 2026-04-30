---
title: Configure NGINX App Protect with NGINX Ingress Controller
weight: 200
toc: true
nd-content-type: how-to
nd-product: INGRESS
nd-docs: DOCS-1866
---

## Overview

This document explains how to use F5 NGINX Ingress Controller to configure [F5 WAF for NGINX v5]({{< ref "/waf/" >}}).

{{< call-out "note" >}} There are complete NGINX Ingress Controller with F5 WAF for NGINX [example resources on GitHub](https://github.com/nginx/kubernetes-ingress/tree/v{{< nic-version >}}/examples/custom-resources/app-protect-waf-v5). {{< /call-out >}}

## Global configuration

NGINX Ingress Controller has global configuration parameters that match those in F5 WAF for NGINX. They are found in the [ConfigMap resource]({{< ref "/nic/configuration/global-configuration/configmap-resource.md#modules" >}}): the F5 WAF for NGINX parameters are prefixed with `app-protect*`.

## Enable F5 WAF for NGINX v5

F5 WAF for NGINX v5 can be enabled and configured for custom resources only(VirtualServer, VirtualServerRoute). You need to create a Policy Custom Resource referencing a policy bundle, then add it to the VirtualServer/VirtualServerRoute definition. Additional detail can be found in the [Policy Resource documentation]({{< ref "/nic/configuration/policy-resource.md#waf" >}}).

---

## F5 WAF for NGINX Bundles

F5 WAF for NGINX bundles for VirtualServer custom resources are defined by creating policy bundles and putting them on a mounted volume accessible from NGINX Ingress Controller.

Before applying a policy, a WAF policy bundle must be created, then copied to a volume mounted to `/etc/app_protect/bundles`.

{{< call-out "note" >}} NGINX Ingress Controller supports `securityLogs` for policy bundles. Log bundles must also be copied to a volume mounted to `/etc/app_protect/bundles`. {{< /call-out >}}

This example shows how a policy is configured by referencing a generated WAF Policy Bundle:

```yaml
apiVersion: k8s.nginx.org/v1
kind: Policy
metadata:
  name: <policy_name>
spec:
  waf:
    enable: true
    apBundle: "<policy_bundle_name>.tgz"
```

This example shows the same policy as above but with a log bundle used for security log configuration:

```yaml
apiVersion: k8s.nginx.org/v1
kind: Policy
metadata:
  name: <policy_name>
spec:
  waf:
    enable: true
    apBundle: "<policy_bundle_name>.tgz"
    securityLogs:
    - enable: true
      apLogBundle: "<log_bundle_name>.tgz"
      logDest: "syslog:server=syslog-svc.default:514"
```

---

## IP Intelligence {#ip-intelligence}

IP intelligence lets you restrict access based on the source IP address reputation. You can block traffic from known malicious sources such as botnets, scanners, tor proxies, and more.

{{< call-out "note" >}} IP intelligence requires the `waf-ip-intelligence` container to be deployed. See the [installation guide]({{< ref "/nic/integrations/app-protect-waf-v5/installation.md#enable-ip-intelligence" >}}) for setup instructions. {{< /call-out >}}

### Configure IP intelligence in policy bundles

When creating policy JSON files for compilation into bundles, include the IP intelligence configuration:

```json
{
    "policy": {
        "name": "ip_intelligence_policy",
        "template": {
            "name": "POLICY_TEMPLATE_NGINX_BASE"
        },
        "applicationLanguage": "utf-8",
        "enforcementMode": "blocking",
        "blocking-settings": {
            "violations": [
                {
                    "name": "VIOL_MALICIOUS_IP",
                    "alarm": true,
                    "block": true
                }
            ]
        },
        "ip-intelligence": {
            "enabled": true,
            "ipIntelligenceCategories": [
                {
                    "category": "BotNets",
                    "alarm": true,
                    "block": true
                },
                {
                    "category": "Scanners",
                    "alarm": true,
                    "block": true
                },
                {
                    "category": "Anonymous Proxy",
                    "alarm": true,
                    "block": true
                },
                {
                    "category": "Tor Proxies",
                    "alarm": true,
                    "block": true
                }
            ]
        }
    }
}
```

Compile this policy into a bundle using the WAF Compiler, then copy the bundle to the `/etc/app_protect/bundles` volume. See [Compile WAF policies]({{< ref "/nic/integrations/app-protect-waf-v5/compile-waf-policies.md" >}}) for details on creating policy bundles.

### Available IP intelligence categories

You can configure each category independently with `alarm` and `block` settings:

- Anonymous Proxy
- BotNets
- Cloud-based Services
- Denial of Service
- Infected Sources
- Mobile Threats
- Phishing Proxies
- Scanners
- Spam Sources
- Tor Proxies
- Web Attacks
- Windows Exploits

Setting `"block": true` rejects requests from IP addresses in that category. Setting `"alarm": true` creates a log entry for the event.

The IP address database is managed by an external provider and updates every 1 minute by default. Addresses may be added, removed, or moved between categories based on reported activity.

For the full policy configuration reference, see the [IP intelligence documentation]({{< ref "/waf/policies/ip-intelligence.md#configure-policies-for-ip-intelligence" >}}).

---

## Configure NGINX Plus Ingress Controller using Virtual Server resources

This example shows how to deploy NGINX Ingress Controller with NGINX Plus and F5 WAF for NGINX v5, deploy a simple web application, and then configure load balancing and WAF protection for that application using the VirtualServer resource.

{{< call-out "note" >}} You can find the files for this example on [GitHub](https://github.com/nginx/kubernetes-ingress/tree/v{{< nic-version >}}/examples/custom-resources/app-protect-waf-v5).{{< /call-out >}}

### Prerequisites

1. Follow the installation [instructions]({{< ref "/nic/integrations/app-protect-waf-v5/installation.md" >}}) to deploy NGINX Ingress Controller with NGINX Plus and F5 WAF for NGINX version 5.

2. Save the public IP address of NGINX Ingress Controller into a shell variable:

   ```shell
    IC_IP=XXX.YYY.ZZZ.III
   ```

3. Save the HTTP port of NGINX Ingress Controller into a shell variable:

   ```shell
    IC_HTTP_PORT=<port number>
   ```

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

### Deploy the WAF Policy

{{< call-out "note" >}} Configuration settings in the Policy resource enable WAF protection by configuring F5 WAF for NGINX with the log configuration created in the previous step. The policy bundle referenced as `your_policy_bundle_name.tgz` need to be created and placed in the `/etc/app_protect/bundles` volume first.{{< /call-out >}}

Create and deploy the WAF policy.

 ```shell
  kubectl apply -f https://raw.githubusercontent.com/nginx/kubernetes-ingress/v{{< nic-version >}}/examples/custom-resources/app-protect-waf-v5/waf.yaml
 ```

### Configure load balancing

{{< call-out "note" >}} VirtualServer references the `waf-policy` created in Step 3.{{< /call-out >}}

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
