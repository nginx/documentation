---
title: Upgrade NGINX Gateway Fabric
weight: 700
toc: true
type: how-to
product: NGF
nd-docs: DOCS-1852
---

This document describes how to upgrade NGINX Gateway Fabric when a new version releases.

It covers the necessary steps for minor versions as well as major versions (such as 1.x to 2.x).

Many of the nuances in upgrade paths relate to how custom resource definitions (CRDs) are managed.

{{< tip >}}

To avoid interruptions, review the [Delay pod termination for zero downtime upgrades](#configure-delayed-pod-termination-for-zero-downtime-upgrades) section.

{{< /tip >}}


## Minor NGINX Gateway Fabric upgrades

{{< important >}} NGINX Plus users need a JWT secret before upgrading from version 1.4.0 to 1.5.x.

Follow the steps in [Set up the JWT]({{< ref "/ngf/install/nginx-plus.md#set-up-the-jwt" >}}) to create the Secret.

{{< /important >}}


### Upgrade Gateway resources

To upgrade your Gateway API resources, take the following steps:

- Use [Technical specifications]({{< ref "/ngf/reference/technical-specifications.md" >}}) to verify your Gateway API resources are compatible with your NGINX Gateway Fabric version.
- Review the [release notes](https://github.com/kubernetes-sigs/gateway-api/releases) for any important upgrade-specific information.

To upgrade the Gateway API resources, run the following command:

```shell
kubectl kustomize "https://github.com/nginx/nginx-gateway-fabric/config/crd/gateway-api/standard?ref=v{{< version-ngf >}}" | kubectl apply -f -
```

If you installed NGINX Gateway from the experimental channel, use this instead:

```shell
kubectl kustomize "https://github.com/nginx/nginx-gateway-fabric/config/crd/gateway-api/experimental?ref=v{{< version-ngf >}}" | kubectl apply -f -
```

### Upgrade NGINX Gateway Fabric CRDs

Run the following command to upgrade the CRDs:

```shell
kubectl apply --server-side -f https://raw.githubusercontent.com/nginx/nginx-gateway-fabric/v{{< version-ngf >}}/deploy/crds.yaml
```

{{< note >}}

Ignore the following warning, as it is expected.

```text
Warning: kubectl apply should be used on resource created by either kubectl create --save-config or kubectl apply.
```

{{< /note >}}

### Upgrade NGINX Gateway Fabric release

{{< tabs name="upgrade-release" >}}

{{% tab name="Helm" %}}

{{< important >}} If you are using NGINX Plus and have a different Secret name than the default `nplus-license` name, specify the Secret name by setting `--set nginx.usage.secretName=<secret-name>` when running `helm upgrade`. {{< /important >}}

To upgrade the release with Helm, you can use the OCI registry, or download the chart and upgrade from the source.

If needed, replace `ngf` with your chosen release name.

**Upgrade from the OCI registry**

```shell
helm upgrade ngf oci://ghcr.io/nginx/charts/nginx-gateway-fabric -n nginx-gateway
```

**Upgrade from sources**

{{< include "/ngf/installation/helm/pulling-the-chart.md" >}}

To upgrade, run the following command:

```shell
helm upgrade ngf . -n nginx-gateway
```

{{% /tab %}}

{{% tab name="Manifests" %}}

Select the deployment manifest that matches your current deployment from options available in the [Deploy NGINX Gateway Fabric]({{< ref "/ngf/install/manifests.md#deploy-nginx-gateway-fabric-1">}}) section and apply it.

{{% /tab %}}

{{< /tabs>}}

## Upgrade from v1.x to v2.x

This section provides step-by-step instructions for upgrading NGINX Gateway Fabric from version 1.x to 2.x, highlighting key architectural changes, expected downtime, and important considerations for CRDs.

To upgrade NGINX Gateway Fabric from version 1.x to the new architecture in version 2.x, you must uninstall the existing NGINX Gateway Fabric CRDs and deployment, and perform a fresh installation. This will cause brief downtime during the upgrade process.

{{<note>}} You do not need to uninstall the Gateway API CRDs during the upgrade. These resources are compatible with the new NGINX Gateway Fabric version. {{</note>}}

### Uninstall NGINX Gateway Fabric v1.x

To remove the previous version 1.x of NGINX Gateway Fabric, follow these steps:

First, run the following command to uninstall NGINX Gateway Fabric from the `nginx-gateway` namespace, and update `ngf` to your release name if it is different:

```shell
helm uninstall ngf -n nginx-gateway
```

Afterwards, remove CRDs associated with NGINX Gateway Fabric version 1.x with the following command:

```shell
kubectl delete -f https://raw.githubusercontent.com/nginx/nginx-gateway-fabric/v1.6.2/deploy/crds.yaml
```

### Install NGINX Gateway Fabric 2.x

{{< important >}}

Before installing 2.x, we recommend following [Add certificates for secure authentication]({{< ref "/ngf/install/secure-certificates.md" >}}).

By default, NGINX Gateway Fabric installs self-signed certificates, which may be unsuitable for a production environment.

{{< /important >}}

{{<tabs name="install-ngf-2.x">}}

{{%tab name="Helm"%}}

Use the following `helm install` command to install the latest stable NGINX Gateway Fabric release in the `nginx-gateway` namespace. It will also install the CRDs required for the deployment:

```shell
helm install ngf oci://ghcr.io/nginx/charts/nginx-gateway-fabric --create-namespace -n nginx-gateway
```

For customization options during the Helm installation process, view the [Install NGINX Gateway Fabric with Helm]({{< ref "/ngf/install/helm.md" >}}) topic.

{{% /tab %}}

{{%tab name="Manifests"%}}

Apply the new CRDs with the following command:

```shell
kubectl apply --server-side -f https://raw.githubusercontent.com/nginx/nginx-gateway-fabric/v{{< version-ngf >}}/deploy/crds.yaml
```

Next, install the latest stable release of NGINX Gateway Fabric in the `nginx-gateway` namespace with the following command:

```shell
kubectl apply -f https://raw.githubusercontent.com/nginx/nginx-gateway-fabric/v{{< version-ngf >}}/deploy/default/deploy.yaml
```

For customization options during the Manifest installation process, view the [Install NGINX Gateway Fabric with Manifests]({{< ref "/ngf/install/manifests.md" >}}) topic.

{{% /tab %}}

{{</tabs>}}

### Architecture changes

With this release, NGINX Gateway Fabric adopts a new architecture that separates the control plane and data plane into independent deployments. This separation improves scalability, security, and operational clarity.

The control plane is a Kubernetes controller that watches Gateway API and Kubernetes resources (e.g., Services, Endpoints, Secrets) and dynamically provisions NGINX data plane deployments for each Gateway.

NGINX configurations are generated by the control plane and securely delivered to the data planes via gRPC, using the NGINX Agent. TLS is enabled by default, with optional integration with `cert-manager`.

Each data plane pod runs NGINX alongside the Agent, which applies config updates and handles reloads without shared volumes or signals. This design ensures dynamic, per-Gateway traffic management and operational isolation.

New fields have been added to the `NginxProxy` resource to configure infrastructure-related settings for data plane deployments. The `NginxProxy` resource is now a namespaced-scoped resource, instead of a cluster-scoped resource, and can be modified at either the Gateway or GatewayClass level. These new fields provide the flexibility to customize deployment and service configurations.

For detailed instructions on how to modify these settings, refer to the [Configure infrastructure-related settings]({{< ref "/ngf/how-to/data-plane-configuration.md#configure-infrastructure-related-settings" >}}) guide.

### Key links for the version 2.x update

- To read more on [modifying data plane configuration]({{< ref "/ngf/how-to/data-plane-configuration.md" >}}).
- To learn more about [deploying a Gateway for data plane instances]({{< ref "/ngf/install/deploy-data-plane.md" >}}).
- To add secure [authentication to control plane and data planes]({{< ref "/ngf/install/secure-certificates.md" >}}).
- To read more about [architecture changes]({{< ref "/ngf/overview/gateway-architecture.md" >}}).
- For detailed [API reference]({{< ref "/ngf/reference/api.md" >}}).

## Access NGINX Gateway Fabric 1.x documentation

The documentation website is intended for the latest version of NGINX Gateway Fabric.

To review documentation prior to 2.x, check out the desired release branch (such as _release-1.6_):

```shell
git clone git@github.com:nginx/nginx-gateway-fabric.git
git checkout release-1.6
```

To review the documentation in a local webserver, run _make watch_ in the _/site_ folder:

```shell
cd site
make watch
```
```text
Hugo is available and has a version greater than 133. Proceeding with build.
hugo --bind 0.0.0.0 -p 1313 server --disableFastRender
Watching for changes in /home/<your-user>/nginx-gateway-fabric/site/{content,layouts,static}
Watching for config changes in /home/<your-user>/nginx-gateway-fabric/site/config/_default, /home/<your-user>/nginx-gateway-fabric/site/config/development, /home/<your-user>/nginx-gateway-fabric/site/go.mod
Start building sites …
hugo v0.135.0-f30603c47f5205e30ef83c70419f57d7eb7175ab linux/amd64 BuildDate=2024-09-27T13:17:08Z VendorInfo=gohugoio


                   | EN
-------------------+------
  Pages            |  72
  Paginator pages  |   0
  Non-page files   |   0
  Static files     | 176
  Processed images |   0
  Aliases          |   9
  Cleaned          |   0

Built in 213 ms
Environment: "development"
Serving pages from disk
Web Server is available
```

You can then follow [this localhost link](http://localhost:1313/nginx-gateway-fabric/) for 1.x NGINX Gateway Fabric documentation.

## Upgrade from NGINX Open Source to NGINX Plus

{{< important >}}

Ensure that you [Set up the JWT]({{< ref "/ngf/install/nginx-plus.md#set-up-the-jwt" >}}) before upgrading. These instructions only apply to Helm.

{{< /important >}}

To upgrade from NGINX Open Source to NGINX Plus, update the Helm command to include the necessary values for Plus:

{{< note >}} If applicable:

- Replace the F5 Container registry `private-registry.nginx.com` with your internal registry for your NGINX Plus image
- Replace `nginx-plus-registry-secret` with your Secret name containing the registry credentials
- Replace `ngf` with your chosen release name.
{{< /note >}}


```shell
helm upgrade ngf oci://ghcr.io/nginx/charts/nginx-gateway-fabric  --set nginx.image.repository=private-registry.nginx.com/nginx-gateway-fabric/nginx-plus --set nginx.plus=true --set nginx.imagePullSecret=nginx-plus-registry-secret -n nginx-gateway
```

## Delay pod termination for zero downtime upgrades {#configure-delayed-pod-termination-for-zero-downtime-upgrades}

{{< include "/ngf/installation/delay-pod-termination/delay-pod-termination-overview.md" >}}

Follow these steps to configure delayed pod termination:

1. Open the `values.yaml` for editing.

1. **Add delayed shutdown hooks**:

   - In the `values.yaml` file, add `lifecycle: preStop` hooks to both the `nginx` and `nginx-gateway` container definitions. These hooks instruct the containers to delay their shutdown process, allowing time for connections to close gracefully. Update the `sleep` value to what works for your environment.

     ```yaml
      nginxGateway:
      <...>
      lifecycle:
          preStop:
          exec:
              command:
              - /usr/bin/gateway
              - sleep
              - --duration=40s # This flag is optional, the default is 30s

      nginx:
      <...>
      lifecycle:
          preStop:
          exec:
              command:
              - /bin/sleep
              - "40"
     ```

1. **Set the termination grace period**:

   - {{< include "/ngf/installation/delay-pod-termination/termination-grace-period.md">}}

1. Save the changes.

{{<see-also>}}
For additional information on configuring and understanding the behavior of containers and pods during their lifecycle, refer to the following Kubernetes documentation:

- [Container Lifecycle Hooks](https://kubernetes.io/docs/concepts/containers/container-lifecycle-hooks/#container-hooks)
- [Pod Lifecycle](https://kubernetes.io/docs/concepts/workloads/Pods/Pod-lifecycle/#Pod-termination)

{{</see-also>}}