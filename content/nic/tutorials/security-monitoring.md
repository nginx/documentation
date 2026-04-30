---
title: Connect F5 WAF for NGINX to NGINX Security Monitoring
toc: true
weight: 1800
nd-content-type: how-to
nd-product: INGRESS
nd-docs: DOCS-1856
---

This document explains how to use NGINX Ingress Controller to configure NGINX Agent for sending F5 WAF for NGINX metrics to NGINX Security Monitoring.

You can send security metrics to either:

- **NGINX Instance Manager** using NGINX Agent 2
- **NGINX One Console** using NGINX Agent 3 (available starting with NGINX Ingress Controller 5.5.0, using images with the `-agent` suffix)

{{<tabs name="setup-security-monitoring">}}

{{%tab name="NGINX Instance Manager"%}}

## Before you begin

This guide assumes that you have an installation of NGINX Instance Manager with NGINX Security Monitoring which is reachable from the Kubernetes cluster on which NGINX Ingress Controller is deployed.

NGINX Ingress Controller images that include F5 WAF for NGINX also include NGINX Agent 2. See the [Technical specifications]({{< ref "/nic/technical-specifications.md#images-with-nginx-plus" >}}) for the full list of available image variants.

## Deploy NGINX Ingress Controller with NGINX Agent

### Using Helm

1. Add the below arguments to the `values.yaml` file:

    ```yaml
    nginxAgent:
        enable: true
        instanceManager:
            host: "<FQDN or IP address of NGINX Instance Manager>"
    ```

2. Follow the [Installation with Helm]({{< ref "/nic/install/helm.md" >}}) instructions to deploy NGINX Ingress Controller with custom resources enabled, and optionally set other `nginxAgent.*` values if required.

### Using Manifests

{{< call-out "note" >}} The `-agent-instance-group` flag is required when using NGINX Instance Manager with NGINX Agent 2. It is not required when using NGINX Agent 3.{{< /call-out >}}

1. Add the below arguments to the `args` section of your NGINX Ingress Controller Deployment, DaemonSet, or StatefulSet:

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
        - metrics
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

3. Mount the ConfigMap to the NGINX Ingress Controller pod at `/etc/nginx-agent/nginx-agent.conf` and the dynamic agent config at `/var/lib/nginx-agent` by adding the following to your Deployment, DaemonSet, or StatefulSet:

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

4. Follow the [Installation with Manifests]({{< ref "/nic/install/manifests.md" >}}) instructions to deploy NGINX Ingress Controller with custom resources enabled.

Once installed, the pods will be visible in the NGINX Instance Manager Instances dashboard.

{{%/tab%}}

{{%tab name="NGINX One Console"%}}

## Before you begin

This guide assumes that you have an NGINX One Console account with access to create data plane keys.

- Create a [data plane key]({{< ref "/nginx-one-console/connect-instances/create-manage-data-plane-keys.md" >}}) from NGINX One Console. Pay attention to the expiration date of that key.
- Create a Kubernetes Secret with the data plane key in the same namespace where NGINX Ingress Controller will be deployed:

    ```shell
    kubectl create secret generic dataplane-key \
      --from-literal=dataplane.key=<Your Dataplane Key> \
      -n <namespace>
    ```

- Use an image variant with the `-agent` suffix, available starting with NGINX Ingress Controller 5.5.0 (for example, `debian-plus-nap-agent` for F5 WAF for NGINX v4, or `debian-plus-nap-v5-agent` for v5). Images without the `-agent` suffix include NGINX Agent 2 and are not compatible with NGINX One Console. See the [Technical specifications]({{< ref "/nic/technical-specifications.md#images-with-nginx-plus" >}}) for the full list of available image variants.

## Deploy NGINX Ingress Controller with NGINX Agent

### Using Helm

1. Add the below arguments to the `values.yaml` file:

    ```yaml
    controller:
      nginxplus: true
      appprotect:
        enable: true
    nginxAgent:
      enable: true
      dataplaneKeySecretName: "<data_plane_key_secret_name>"
      endpointHost: "agent.connect.nginx.com"
      endpointPort: 443
    ```

    For F5 WAF for NGINX v5, also set `controller.appprotect.v5: true` and configure the enforcer and config manager images. See the [F5 WAF for NGINX v5 installation guide]({{< ref "/nic/integrations/app-protect-waf-v5/installation.md" >}}) for details on the additional Helm values required.

2. Follow the [Installation with Helm]({{< ref "/nic/install/helm.md" >}}) instructions to deploy NGINX Ingress Controller with custom resources enabled.

See the [Connect NGINX Ingress Controller to NGINX One Console]({{< ref "/nginx-one-console/k8s/add-nic.md" >}}) guide for more details on connecting to NGINX One Console.

### Using Manifests

{{< call-out "note" >}} When using NGINX One Console with NGINX Agent 3, the `-agent-instance-group` flag is not required.{{< /call-out >}}

1. Add the below argument to the `args` section of your NGINX Ingress Controller Deployment, DaemonSet, or StatefulSet:

    ```yaml
    args:
      - -agent=true
    ```

2. Create a Kubernetes Secret with the data plane key if you have not already done so:

    ```shell
    kubectl create secret generic dataplane-key \
      --from-literal=dataplane.key=<Your Dataplane Key> \
      -n <namespace>
    ```

3. Create a ConfigMap with an `nginx-agent.conf` file:

   ```yaml
    kind: ConfigMap
    apiVersion: v1
    metadata:
      name: nginx-agent-config
      namespace: <namespace where NGINX Ingress Controller will be installed>
    data:
      nginx-agent.conf: |-
        log:
          level: info
          path: ""

        allowed_directories:
          - /etc/nginx
          - /usr/lib/nginx/modules
          - /etc/app_protect

        features:
          - certificates
          - connection
          - metrics
          - file-watcher
          - logs-nap

        command:
          server:
            host: agent.connect.nginx.com
            port: 443
          auth:
            tokenpath: "/etc/nginx-agent/secrets/dataplane.key"
          tls:
            skip_verify: false

        collector:
          log:
            path: "stdout"
   ```

   The `logs-nap` feature enables NGINX Agent to collect F5 WAF for NGINX security events. The `/etc/app_protect` entry in `allowed_directories` is required for WAF-enabled deployments.

{{< call-out "note" >}} The `features` list must not contain `nginx-config-async` or `nginx-ssl-config` as these features can cause conflicts with NGINX Ingress Controller.{{< /call-out >}}

4. Mount the ConfigMap and the data plane key Secret to the NGINX Ingress Controller pod:

   ```yaml
   volumes:
     - name: agent-conf
       configMap:
         name: nginx-agent-config
     - name: agent-etc
       emptyDir: {}
     - name: dataplane-key
       secret:
         secretName: "<data_plane_key_secret_name>"
     - name: agent-dynamic
       emptyDir: {}
   ```

   ```yaml
   volumeMounts:
     - name: agent-etc
       mountPath: /etc/nginx-agent
     - name: agent-conf
       mountPath: /etc/nginx-agent/nginx-agent.conf
       subPath: nginx-agent.conf
     - name: dataplane-key
       mountPath: /etc/nginx-agent/secrets
     - name: agent-dynamic
       mountPath: /var/lib/nginx-agent
   ```

5. Follow the [Installation with Manifests]({{< ref "/nic/install/manifests.md" >}}) instructions to deploy NGINX Ingress Controller with custom resources enabled.

Once installed, the pods will be visible in NGINX One Console. See [Verify a connection to NGINX One Console]({{< ref "/nginx-one-console/k8s/add-nic.md#verify-a-connection-to-nginx-one-console" >}}) for details.

{{%/tab%}}

{{</tabs>}}

## Configuring F5 WAF for NGINX to send metrics to NGINX Agent

NGINX Agent runs a syslog listener which F5 WAF for NGINX can be configured to send logs to, which will then allow NGINX Agent to send metrics to NGINX Security Monitoring. This applies to both NGINX Instance Manager (NGINX Agent 2) and NGINX One Console (NGINX Agent 3) deployments. When using NGINX Agent 3, the `logs-nap` feature handles syslog collection automatically.

Configure the WAF Policy `logDest` to send logs to the NGINX Agent syslog listener at `syslog:server=127.0.0.1:1514`.

For F5 WAF for NGINX v4, see the [VirtualServer example](https://github.com/nginx/kubernetes-ingress/tree/v{{< nic-version >}}/examples/custom-resources/security-monitoring) and [Ingress example](https://github.com/nginx/kubernetes-ingress/tree/v{{< nic-version >}}/examples/ingress-resources/security-monitoring) in the repository. Do not modify the APLogConf in these examples, as NGINX Agent expects a specific log format.

For F5 WAF for NGINX v5, see the [VirtualServer example](https://github.com/nginx/kubernetes-ingress/tree/v{{< nic-version >}}/examples/custom-resources/security-monitoring-v5) and [Ingress example](https://github.com/nginx/kubernetes-ingress/tree/v{{< nic-version >}}/examples/ingress-resources/security-monitoring-v5) in the repository. Policy and log configurations are compiled into bundles (`.tgz` files) instead of using APPolicy and APLogConf custom resources. The log bundle must be compiled from a log profile that matches the format required by NGINX Security Monitoring. See the [F5 WAF for NGINX v5 configuration guide]({{< ref "/nic/integrations/app-protect-waf-v5/configuration.md" >}}) for details on compiling policy and log bundles.

When using NGINX One Console, you can create and manage WAF policies under **WAF > Policies**. Once you have a policy, compile it into a `.tgz` bundle using the waf-compiler image and copy it to the pod at `/etc/app_protect/bundles/`. See [Compile WAF Policy from JSON to Bundle]({{< ref "/nic/install/waf-helm.md#compile-waf-policy-from-json-to-bundle" >}}) for the compilation steps.

For the required log bundle, the `secops_dashboard` log profile is available to download directly from **WAF > Log Profiles** in NGINX One Console — no compilation needed. See [Set up security monitoring](https://docs.nginx.com/nginx-one-console/waf-integration/waf-security-dashboard/set-up-security-monitoring/) in the NGINX One Console documentation for details.

## Upgrading from NGINX Instance Manager to NGINX One Console

If you have an existing deployment using NGINX Instance Manager (NGINX Agent 2) and want to migrate to NGINX One Console (NGINX Agent 3, available starting with NGINX Ingress Controller 5.5.0), follow these steps:

1. **Obtain a data plane key** from NGINX One Console. See [Create and manage data plane keys]({{< ref "/nginx-one-console/connect-instances/create-manage-data-plane-keys.md" >}}).

2. **Create the data plane key Secret** in the same namespace as your NGINX Ingress Controller deployment:

    ```shell
    kubectl create secret generic dataplane-key \
      --from-literal=dataplane.key=<Your Dataplane Key> \
      -n <namespace>
    ```

3. **Update your deployment** to use NGINX Agent 3:

{{<tabs name="upgrade-agent">}}

{{%tab name="Using Helm"%}}

Update your `values.yaml` to replace the NGINX Instance Manager configuration with NGINX One Console configuration:

```yaml
# Remove these values:
# nginxAgent:
#   instanceManager:
#     host: "nim.example.com"
#   syslog: ...
#   napMonitoring: ...

# Add NGINX One Console configuration:
controller:
  image:
    repository: <your-registry>/nginx-plus-ingress
    # Use an image with the -agent suffix (available starting with NIC 5.5.0), for example:
    # debian-plus-nap-agent (WAF v4) or debian-plus-nap-v5-agent (WAF v5)
  nginxplus: true
  appprotect:
    enable: true
nginxAgent:
  enable: true
  dataplaneKeySecretName: "dataplane-key"
  endpointHost: "agent.connect.nginx.com"
  endpointPort: 443
```

Run the upgrade:

```shell
helm upgrade <release-name> oci://ghcr.io/nginx/charts/nginx-ingress --version {{< nic-helm-version >}} \
  -f values.yaml \
  -n <namespace>
```

{{%/tab%}}

{{%tab name="Using Manifests"%}}

1. Update the container image in your Deployment or DaemonSet to an image variant with the `-agent` suffix, available starting with NGINX Ingress Controller 5.5.0 (for example, `debian-plus-nap-agent` for WAF v4, or `debian-plus-nap-v5-agent` for WAF v5).

2. Update the container args to remove `-agent-instance-group`:

    ```yaml
    args:
      - -agent=true
      # Remove: - -agent-instance-group=<name>
    ```

3. Replace the `nginx-agent.conf` ConfigMap with the NGINX Agent 3 configuration shown in the [Using NGINX One Console - Using Manifests](#using-nginx-one-console) section above.

4. Update volumes and volumeMounts:

   Remove the NGINX Instance Manager TLS volume and mount:

   ```yaml
   # Remove:
   # - name: nginx-agent-tls
   #   projected:
   #     sources:
   #       - secret:
   #           name: <nim-tls-secret>
   #       - secret:
   #           name: <nim-ca-secret>
   ```

   Add the data plane key volume and mount:

   ```yaml
   volumes:
     - name: dataplane-key
       secret:
         secretName: "dataplane-key"

   volumeMounts:
     - name: dataplane-key
       mountPath: /etc/nginx-agent/secrets
   ```

5. Apply the updated manifests:

    ```shell
    kubectl apply -f <your-deployment-manifest>.yaml
    ```

{{%/tab%}}

{{</tabs>}}

4. **Verify the upgrade** by checking the agent version and connection:

    ```shell
    kubectl exec -it -n <namespace> <pod_name> -- nginx-agent -v
    ```

    The output should show `nginx-agent version v3.x.x`. Check the NGINX One Console dashboard under **Manage > Instances** to confirm your instances appear.

5. **Clean up** old NGINX Instance Manager TLS secrets if they are no longer needed:

    ```shell
    kubectl delete secret <nim-tls-secret> <nim-ca-secret> -n <namespace>
    ```

{{< call-out "note" >}} Your F5 WAF for NGINX Policy resources (APPolicy, APLogConf, or compiled bundles for v5) do not need to change during this migration. The WAF configuration and the `logDest` syslog destination (`syslog:server=127.0.0.1:1514`) remain the same.{{< /call-out >}}
