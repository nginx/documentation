---
title: Connect NGINX Ingress Controller
toc: true
weight: 200
nd-content-type: how-to
nd-product: NONECO
---

This document explains how to connect F5 NGINX Ingress Controller to F5 NGINX One Console using NGINX Agent.
Connecting NGINX Ingress Controller to NGINX One Console enables centralized monitoring of all controller instances.

Once connected, you'll see a **read-only** configuration of NGINX Ingress Controller. For each instance, you can review:

- Read-only configuration file
- Unmanaged SSL/TLS certificates for Control Planes
- F5 WAF for NGINX security events (when using a WAF-enabled image)

## Before you begin

If you do not already have a [data plane key]({{< ref "/nginx-one-console/connect-instances/create-manage-data-plane-keys.md" >}}), you can create one. Pay attention to the expiration date of that key. Any instance that's connected to a data plane key that's expired or revoked will stop working.

You can create a data plane key through the NGINX One Console. Once logged in, select **Manage > Control Planes > Add Control Plane**, and follow the steps shown.

Before connecting NGINX Ingress Controller to NGINX One Console, you need to create a Kubernetes Secret with the data plane key. Use the following command:

```shell
kubectl create secret generic dataplane-key \
  --from-literal=dataplane.key=<Your Dataplane Key> \
  -n <namespace>
```

When you create a Kubernetes Secret, use the same namespace where NGINX Ingress Controller is running.
If you use [`-watch-namespace`]({{< ref "/nic/configuration/global-configuration/command-line-arguments.md#watch-namespace-string" >}}) or [`watch-secret-namespace`]({{< ref "/nic/configuration/global-configuration/command-line-arguments.md#watch-secret-namespace-string" >}}) arguments with NGINX Ingress Controller,
you need to add the dataplane key secret to the watched namespaces. This secret will take approximately 60 - 90 seconds to reload on the pod.

{{< call-out "note" >}}
You can also create a data plane key through the NGINX One Console. Once logged in, select **Manage > Control Planes > Add Control Plane**, and follow the steps shown.
{{< /call-out >}}

### Choosing the right image

Starting with NGINX Ingress Controller 5.5.0, images with F5 WAF for NGINX and NGINX Agent 3 are available using the `-agent` suffix. The image you need depends on your deployment:

| Deployment type | Image variant |
|---|---|
| NGINX (open source) | Default image (no special variant needed) |
| NGINX Plus | `nginx-plus-ingress` |
| NGINX Plus with F5 WAF for NGINX v4 | Use an image with the `-nap-agent` suffix (for example, `debian-plus-nap-agent`) |
| NGINX Plus with F5 WAF for NGINX v5 | Use an image with the `-nap-v5-agent` suffix (for example, `debian-plus-nap-v5-agent`) |

See the [Technical specifications]({{< ref "/nic/technical-specifications.md#images-with-nginx-plus" >}}) for the full list of image variants available for each platform.

## Deploy NGINX Ingress Controller with NGINX Agent

{{<tabs name="deploy-config-resource">}}
{{%tab name="Helm"%}}

Upgrade or install NGINX Ingress Controller with the following command to configure NGINX Agent and connect to NGINX One Console:

- For NGINX:

    ```shell
    helm upgrade --install my-release oci://ghcr.io/nginx/charts/nginx-ingress --version {{< nic-helm-version >}} \
      --set nginxAgent.enable=true \
      --set nginxAgent.dataplaneKeySecretName=<data_plane_key_secret_name> \
      --set nginxAgent.endpointHost=agent.connect.nginx.com
    ```

- For NGINX Plus: (This assumes you have pushed NGINX Ingress Controller image `nginx-plus-ingress` to your private registry `myregistry.example.com`)

    ```shell
    helm upgrade --install my-release oci://ghcr.io/nginx/charts/nginx-ingress --version {{< nic-helm-version >}} \
      --set controller.image.repository=myregistry.example.com/nginx-plus-ingress \
      --set controller.nginxplus=true \
      --set nginxAgent.enable=true \
      --set nginxAgent.dataplaneKeySecretName=<data_plane_key_secret_name> \
      --set nginxAgent.endpointHost=agent.connect.nginx.com
    ```

- For NGINX Plus with F5 WAF for NGINX v4:

    ```shell
    helm upgrade --install my-release oci://ghcr.io/nginx/charts/nginx-ingress --version {{< nic-helm-version >}} \
      --set controller.image.repository=myregistry.example.com/nginx-plus-ingress \
      --set controller.nginxplus=true \
      --set controller.appprotect.enable=true \
      --set nginxAgent.enable=true \
      --set nginxAgent.dataplaneKeySecretName=<data_plane_key_secret_name> \
      --set nginxAgent.endpointHost=agent.connect.nginx.com
    ```

- For NGINX Plus with F5 WAF for NGINX v5, set `controller.appprotect.v5=true` and configure the enforcer and config manager images. See the [F5 WAF for NGINX v5 installation guide]({{< ref "/nic/integrations/app-protect-waf-v5/installation.md" >}}) for the additional Helm values required.

The `dataplaneKeySecretName` is used to authenticate the agent with NGINX One Console. See the [NGINX One Console Docs]({{< ref "/nginx-one-console/connect-instances/create-manage-data-plane-keys.md" >}})
for instructions on how to generate your dataplane key from the NGINX One Console.

Follow the [Installation with Helm]({{< ref "/nic/install/helm.md" >}}) instructions to deploy NGINX Ingress Controller.

{{%/tab%}}
{{%tab name="Manifests"%}}

Add the following flag to the Deployment/DaemonSet file of NGINX Ingress Controller:

```yaml
args:
- -agent=true
```

Create a `ConfigMap` with an `nginx-agent.conf` file:

{{<tabs name="agent-config-manifests">}}

{{%tab name="Without F5 WAF for NGINX"%}}

```yaml
kind: ConfigMap
apiVersion: v1
metadata:
  name: nginx-agent-config
  namespace: <namespace>
data:
  nginx-agent.conf: |-
    log:
      # set log level (error, info, debug; default "info")
      level: info
      # set log path. if empty, don't log to file.
      path: ""

    allowed_directories:
      - /etc/nginx
      - /usr/lib/nginx/modules

    features:
      - certificates
      - connection
      - metrics
      - file-watcher

    ## command server settings
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

{{%/tab%}}

{{%tab name="With F5 WAF for NGINX"%}}

```yaml
kind: ConfigMap
apiVersion: v1
metadata:
  name: nginx-agent-config
  namespace: <namespace>
data:
  nginx-agent.conf: |-
    log:
      # set log level (error, info, debug; default "info")
      level: info
      # set log path. if empty, don't log to file.
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

    ## command server settings
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

{{%/tab%}}

{{</tabs>}}

Make sure to set the namespace in the ConfigMap to the same namespace as NGINX Ingress Controller.
Mount the ConfigMap to the Deployment/DaemonSet file of NGINX Ingress Controller:

```yaml
volumeMounts:
- name: agent-etc
  mountPath: /etc/nginx-agent
- name: nginx-agent-config
  mountPath: /etc/nginx-agent/nginx-agent.conf
  subPath: nginx-agent.conf
- name: dataplane-key
  mountPath: /etc/nginx-agent/secrets
- name: agent-dynamic
  mountPath: /var/lib/nginx-agent
volumes:
- name: nginx-agent-config
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

Follow the [Installation with Manifests]({{< ref "/nic/install/manifests.md" >}}) instructions to deploy NGINX Ingress Controller.

{{%/tab%}}
{{</tabs>}}

## Configure F5 WAF for NGINX security monitoring {#configure-waf-security-monitoring}

When deploying NGINX Ingress Controller with F5 WAF for NGINX, you can forward WAF security events to NGINX One Console for centralized security monitoring.

For full setup instructions, including WAF policy configuration and examples, see [Connect F5 WAF for NGINX to NGINX Security Monitoring]({{< ref "/nic/tutorials/security-monitoring.md" >}}).

## Verify a connection to NGINX One Console

After deploying NGINX Ingress Controller with NGINX Agent, you can verify the connection to NGINX One Console.
Log in to your F5 Distributed Cloud Console account. Select **NGINX One > Visit Service**. In the dashboard, go to **Manage > Instances**. You should see your instances listed by name. The instance name matches both the hostname and the pod name.

## Troubleshooting

If you encounter issues connecting your instances to NGINX One Console, try the following commands:

Check the NGINX Agent version:

```shell
kubectl exec -it -n <namespace> <nginx_ingress_pod_name> -- nginx-agent -v
```

Verify that the output shows `nginx-agent version v3.x.x`. If the agent version is v2, you are using an image that includes NGINX Agent 2 instead of NGINX Agent 3. Use an image variant with the `-agent` suffix (available starting with NGINX Ingress Controller 5.5.0):

- For NGINX Plus without WAF: use the standard NGINX Plus image
- For F5 WAF for NGINX v4: use an image with the `-nap-agent` suffix (for example, `debian-plus-nap-agent`)
- For F5 WAF for NGINX v5: use an image with the `-nap-v5-agent` suffix (for example, `debian-plus-nap-v5-agent`)

Check the NGINX Agent configuration:

```shell
kubectl exec -it -n <namespace> <nginx_ingress_pod_name> -- cat /etc/nginx-agent/nginx-agent.conf
```

If using F5 WAF for NGINX, verify that `logs-nap` is listed under `features` and `/etc/app_protect` is listed under `allowed_directories`.

Check NGINX Agent logs:

```shell
kubectl exec -it -n <namespace> <nginx_ingress_pod_name> -- nginx-agent
```

Select the instance associated with your deployment of NGINX Ingress Controller. Under the **Details** tab, you'll see information associated with:

- Unmanaged SSL/TLS certificates for Control Planes
- Configuration recommendations

Under the **Configuration** tab, you'll see a **read-only** view of the configuration files.
