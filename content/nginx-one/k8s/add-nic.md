---
title: Connect to NGINX One Console
toc: true
weight: 200
nd-content-type: how-to
nd-product: NGINX One
---

This document explains how to connect F5 NGINX Ingress Controller <!-- and F5 NGINX Gateway Fabric -->to F5 NGINX One Console using NGINX Agent.
Connecting NGINX Ingress Controller to NGINX One Console enables centralized monitoring of all controller instances.

Once connected, you'll see a **read-only** configuration of NGINX Ingress Controller. For each instance, you can review:

- Read-only configuration file
- Unmanaged SSL/TLS certificates for Control Planes

## Before you begin

Before connecting NGINX Ingress Controller to NGINX One Console, you need to create a Kubernetes Secret with the data plane key. Use the following command:

```shell
kubectl create secret generic dataplane-key \
  --from-literal=dataplane.key=<Your Dataplane Key> \
  -n <namespace>
```

When you create a Kubernetes Secret, use the same namespace where NGINX Ingress Controller is running. 
If you use [`-watch-namespace`]({{< ref "/nic/configuration/global-configuration/command-line-arguments.md#watch-namespace-string" >}}) or [`watch-secret-namespace`]({{< ref "/nic/configuration/global-configuration/command-line-arguments.md#watch-secret-namespace-string" >}}) arguments with NGINX Ingress Controller, 
you need to add the dataplane key secret to the watched namespaces. This secret will take approximately 60 - 90 seconds to reload on the pod.

{{<note>}}
You can also create a data plane key through the NGINX One Console. Once loggged in, select **Manage > Control Planes > Add Control Plane**, and follow the steps shown.
{{</note>}}

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

The `dataplaneKeySecretName` is used to authenticate the agent with NGINX One Console. See the [NGINX One Console Docs]({{< ref "/nginx-one/connect-instances/create-manage-data-plane-keys.md" >}})
for instructions on how to generate your dataplane key from the NGINX One Console.

Follow the [Installation with Helm]({{< ref "/nic/installation/installing-nic/installation-with-helm.md" >}}) instructions to deploy NGINX Ingress Controller.

{{%/tab%}}
{{%tab name="Manifests"%}}

Add the following flag to the Deployment/DaemonSet file of NGINX Ingress Controller:

```yaml
args:
- -agent=true
```

Create a `ConfigMap` with an `nginx-agent.conf` file:

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
```      

Make sure to set the namespace in the nginx-agent.config to the same namespace as NGINX Ingress Controller.
Mount the ConfigMap to the Deployment/DaemonSet file of NGINX Ingress Controller:

```yaml
volumeMounts:
- name: nginx-agent-config
  mountPath: /etc/nginx-agent/nginx-agent.conf
  subPath: nginx-agent.conf
- name: dataplane-key
  mountPath: /etc/nginx-agent/secrets
volumes:
- name: nginx-agent-config
  configMap:
    name: nginx-agent-config
- name: dataplane-key
  secret:
    secretName: "<data_plane_key_secret_name>"
```

Follow the [Installation with Manifests]({{< ref "/nic/installation/installing-nic/installation-with-manifests.md" >}}) instructions to deploy NGINX Ingress Controller.

{{%/tab%}}
{{</tabs>}}

## Verify a connection to NGINX One Console

After deploying NGINX Ingress Controller <!-- or NGINX Gateway Fabric --> with NGINX Agent, you can verify the connection to NGINX One Console.
Log in to your F5 Distributed Cloud Console account. Select **NGINX One > Visit Service**. In the dashboard, go to **Manage > Instances**. You should see your instances listed by name. The instance name matches both the hostname and the pod name.

## Troubleshooting

If you encounter issues connecting your instances to NGINX One Console, try the following commands:

Check the NGINX Agent version:

```shell
kubectl exec -it -n <namespace> <nginx_ingress_pod_name> -- nginx-agent -v
```
  
If nginx-agent version is v3, continue with the following steps.
Otherwise, make sure you are using an image that does not include NGINX App Protect. 

Check the NGINX Agent configuration:

```shell
kubectl exec -it -n <namespace> <nginx_ingress_pod_name> -- cat /etc/nginx-agent/nginx-agent.conf
```

Check NGINX Agent logs:

```shell
kubectl exec -it -n <namespace> <nginx_ingress_pod_name> -- nginx-agent
```

Select the instance associated with your deployment of NGINX Ingress Controller. Under the **Details** tab, you'll see information associated with:

- Unmanaged SSL/TLS certificates for Control Planes 
- Configuration recommendations 

Under the **Configuration** tab, you'll see a **read-only** view of the configuration files.
