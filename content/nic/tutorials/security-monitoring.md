---
title: Connect NGINX App Protect WAF to NGINX Security Monitoring
toc: true
weight: 1800
nd-content-type: how-to
nd-product: NIC
nd-docs: DOCS-1856
---

This document explains how to use NGINX Ingress Controller to configure NGINX Agent for sending F5 NGINX App Protect WAF metrics to NGINX Security Monitoring.

## Prerequisites

This guide assumes that you have an installation of NGINX Instance Manager with NGINX Security Monitoring which is reachable from the Kubernetes cluster on which NGINX Ingress Controller is deployed.

If you use custom container images, NGINX Agent must be installed along with NGINX App Protect WAF. See the [Dockerfile](https://github.com/nginx/kubernetes-ingress/tree/v{{< nic-version >}}/build/Dockerfile) for examples of how to install NGINX Agent or the [NGINX Agent installation documentation]({{< ref "/agent/installation-upgrade/" >}}) for more information.

## Deploying NGINX Ingress Controller with NGINX Agent configuration

{{<tabs name="deploy-config-resource">}}

{{%tab name="Using Helm"%}}

1. Add the below arguments to the `values.yaml` file:
    ```yaml
    nginxAgent:
        enable: true
        instanceManager:
            host: "<FQDN or IP address of NGINX Instance Manager>"
    ```

2. Follow the [Installation with Helm]({{< ref "/nic/installation/installing-nic/installation-with-helm.md" >}}) instructions to deploy NGINX Ingress Controller with custom resources enabled, and optionally set other `nginxAgent.*` values if required.

{{%/tab%}}

{{%tab name="Using Manifests"%}}

1. Add the below argument to the manifest file of NGINX Ingress Controller:

    ```yaml
    args:
      - -agent=true
      - -agent-instance-group=<NGINX Ingress Controller deployment name>
    ```

2. Create a ConfigMap with an `nginx-agent.conf` file which must be mounted to `/etc/nginx-agent/nginx-agent.conf` in the NGINX Ingress Controller pod.
   ```yaml
    kind: ConfigMap
    apiVersion: v1
    metadata:
      name: <configmap name>
      namespace: <namespace where NGINX Ingress Controller will be installed>
    data:
      nginx-agent.conf: |-
        log:
          level: error
          path: ""
        server:
          host: "<FQDN or IP address of NGINX Instance Manager>"
          grpcPort: 443
        tls:
          enable: true
          skip_verify: false
        features:
        - registration
        - nginx-counting
        - metrics-sender
        - dataplane-status
        extensions:
        - nginx-app-protect
        - nap-monitoring
        nginx_app_protect:
          report_interval: 15s
          precompiled_publication: true
        nap_monitoring:
          collector_buffer_size: 20000
          processor_buffer_size: 20000
          syslog_ip: 127.0.0.1
          syslog_port: 1514
   ```
   See the [NGINX Agent Configuration Overview]({{< ref "/agent/configuration/configuration-overview.md" >}}) for more configuration options.

{{< call-out "note" >}} The `features` list must not contain `nginx-config-async` or `nginx-ssl-config` as these features can cause conflicts with NGINX Ingress Controller.{{< /call-out >}}

3. Make sure that the ConfigMap is mounted to the NGINX Ingress Controller pod at `/etc/nginx-agent/nginx-agent.conf` and the dynamic agent config is mounted at `/var/lib/nginx-agent` by adding the following volumes and volumeMounts to the NGINX Ingress Controller deployment manifest:

   ```yaml
   volumes:
     - name: agent-conf
       configMap:
         name: agent-conf
     - name: agent-dynamic
       emptyDir: {}
   ```

   ```yaml
   volumeMounts:
     - name: agent-conf
       mountPath: /etc/nginx-agent/nginx-agent.conf
       subPath: nginx-agent.conf
     - name: agent-dynamic
       mountPath: /var/lib/nginx-agent
   ```

4. Follow the [Installation with Manifests]({{< ref "/nic/installation/installing-nic/installation-with-manifests.md" >}}) instructions to deploy NGINX Ingress Controller with custom resources enabled.

{{%/tab%}}

{{</tabs>}}

Once NGINX Ingress Controller is installed the pods will be visible in the NGINX Instance Monitoring Instances dashboard.

## Configuring NGINX App Protect WAF to send metrics to NGINX Agent

NGINX Agent runs a syslog listener which NGINX App Protect WAF can be configured to send logs to, which will then allow NGINX Agent to send metrics to NGINX Security Monitoring. The following examples show how to configure NGINX App Protect WAF to log to NGINX Agent.

- [Custom Resources example](https://github.com/nginx/kubernetes-ingress/tree/v{{< nic-version >}}/examples/custom-resources/security-monitoring)
- [Ingress Resources example](https://github.com/nginx/kubernetes-ingress/tree/v{{< nic-version >}}/examples/ingress-resources/security-monitoring)

{{< call-out "note" >}} Modifying the APLogConf in the examples may result in the Security Monitoring integration not working, as NGINX Agent expects a specific log format.{{< /call-out >}}
