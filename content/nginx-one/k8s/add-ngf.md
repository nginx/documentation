---
title: Connect NGINX Gateway Fabric
toc: true
weight: 300
nd-content-type: how-to
nd-product: NGINX One
---

This document explains how to connect F5 NGINX Gateway Fabric to F5 NGINX One Console using NGINX Agent.
Connecting NGINX Gateway Fabric to NGINX One Console enables centralized monitoring of all controller instances.

Once connected, you'll see a **read-only** configuration of NGINX Gateway Fabric. For each instance, you can review:

- Read-only configuration file
- Unmanaged SSL/TLS certificates for Control Planes

## Before you begin

Log in to NGINX One Console. If you need more information, review our [Get started guide]({{< ref "/nginx-one/getting-started.md#before-you-begin" >}}).

You also need:

- Administrator access to a Kubernetes cluster.
- [Helm](https://helm.sh) and [kubectl](https://kubernetes.io/docs/tasks/tools/#kubectl) must be installed locally.


### Create a data plane key

Data plane keys are displayed only once, when you create that key, and cannot be retrieved later.

If you've created and recorded one or more data plane keys, you can edit or revoke those keys. To do so, select **Manage > Data Plane Keys**. NGINX One Console does not store your actual data plane key.

If you've forgotten your data plane key, you can create a new one. Select **Manage > Data Plane Keys > Add Data Plane Key**.

For more options associated with data plane keys, see [Create and manage data plane keys]({{ ref "/nginx-one/connect-instances/create-manage-data-plane-keys" >}}).

### Create a Kubernetes secret with the data plane key
<!-- Maybe this is wrong. I'm assuming that we need to follow this step from the current version of https://docs.nginx.com/nginx-one/k8s/add-nic/#before-you-begin -->
To create a Kubernetes secret with the data play key, use the following command:

   ```shell
   kubectl create secret generic dataplane-key \
     --from-literal=dataplane.key=<Your Dataplane Key> \
     -n <namespace>
   ```

### Install cert-manager

Add the Helm repository:

```shell
helm repo add jetstack https://charts.jetstack.io
helm repo update
```

Install cert-manager:

```shell
helm install \
  cert-manager jetstack/cert-manager \
  --namespace cert-manager \
  --create-namespace \
  --set config.apiVersion="controller.config.cert-manager.io/v1alpha1" \
  --set config.kind="ControllerConfiguration" \
  --set config.enableGatewayAPI=true \
  --set crds.enabled=true
```

This also enables Gateway API features for cert-manager, which can be useful for [securing your workload traffic]({{< ref "/ngf/traffic-security/integrate-cert-manager.md" >}}).

## Install the Gateway API resources
<!-- Corresponds to step 2 in the UX -->
{{< include "/ngf/installation/install-gateway-api-resources.md" >}}

## Install from the OCI registry
<!-- Corresponds to step 3 in the UX -->
{{< include "/ngf/installation/install-oci-registry.md" >}}

### Install from sources {#install-from-sources}
<!-- Corresponds to step 4 in the UX -->
If you prefer to install directly from sources, instead of through the OCI helm registry, use the following steps.

{{< include "/ngf/installation/helm/pulling-the-chart.md" >}}

{{<tabs name="install-helm-src">}}

{{%tab name="NGINX"%}}

To install the chart into the **nginx-gateway** namespace, run the following command:

```shell
helm install ngf . --create-namespace -n nginx-gateway
```

{{% /tab %}}

{{%tab name="NGINX Plus"%}}

{{< note >}} If applicable, replace the F5 Container registry `private-registry.nginx.com` with your internal registry for your NGINX Plus image, and replace `nginx-plus-registry-secret` with your Secret name containing the registry credentials. If your NGINX Plus JWT Secret has a different name than the default `nplus-license`, then define that name using the `nginx.usage.secretName` flag. {{< /note >}}

To install the chart into the **nginx-gateway** namespace, run the following command:

```shell
helm install ngf . --set nginx.image.repository=private-registry.nginx.com/nginx-gateway-fabric/nginx-plus --set nginx.plus=true --set nginx.imagePullSecret=nginx-plus-registry-secret -n nginx-gateway
```

{{% /tab %}}

{{</tabs>}}

`ngf` is the name of the release, and can be changed to any name you want. This name is added as a prefix to the Deployment name.

To wait for the Deployment to be ready, you can either add the `--wait` flag to the `helm install` command, or run the following after installing:

```shell
kubectl wait --timeout=5m -n nginx-gateway deployment/ngf-nginx-gateway-fabric --for=condition=Available
```

## Verify a connection to NGINX One Console

After deploying NGINX Gateway Fabric with NGINX Agent, you can verify the connection to NGINX One Console.
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
kubectl exec -it -n <namespace> <nginx_pod_name> -- cat /etc/nginx-agent/nginx-agent.conf
```

Check NGINX Agent logs:

```shell
kubectl exec -it -n <namespace> <nginx_pod_name> -- nginx-agent
```
