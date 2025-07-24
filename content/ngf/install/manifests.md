---
title: Install NGINX Gateway Fabric with Manifests
weight: 200
toc: true
nd-content-type: how-to
nd-product: NGF
nd-docs: DOCS-1429
---

## Overview

Learn how to install, upgrade, and uninstall NGINX Gateway Fabric using Kubernetes manifests.

## Before you begin

To complete this guide, you'll need to install:

- [kubectl](https://kubernetes.io/docs/tasks/tools/), a command-line interface for managing Kubernetes clusters.
- [Add certificates for secure authentication]({{< ref "/ngf/install/secure-certificates.md" >}}) in a production environment.

{{< important >}} If you’d like to use NGINX Plus, some additional setup is also required: {{</ important >}}

<details closed>
<summary>NGINX Plus JWT setup</summary>

{{< include "/ngf/installation/jwt-password-note.md" >}}

### Download the JWT from MyF5

{{< include "/ngf/installation/nginx-plus/download-jwt.md" >}}

### Create the Docker Registry Secret

{{< include "/ngf/installation/nginx-plus/docker-registry-secret.md" >}}

### Create the NGINX Plus Secret

{{< include "/ngf/installation/nginx-plus/nginx-plus-secret.md" >}}

{{< note >}} For more information on why this is needed and additional configuration options, including how to report to NGINX Instance Manager instead, see the [NGINX Plus Image and JWT Requirement]({{< ref "/ngf/install/nginx-plus.md" >}}) document. {{< /note >}}

</details>

## Deploy NGINX Gateway Fabric

Deploying NGINX Gateway Fabric with Kubernetes manifests takes only a few steps. With manifests, you can configure your deployment exactly how you want. Manifests also make it easy to replicate deployments across environments or clusters, ensuring consistency.

### Install the Gateway API resources

{{< include "/ngf/installation/install-gateway-api-resources.md" >}}

### Deploy the NGINX Gateway Fabric CRDs

#### Stable release

```shell
kubectl apply --server-side -f https://raw.githubusercontent.com/nginx/nginx-gateway-fabric/v{{< version-ngf >}}/deploy/crds.yaml
```

#### Edge version

```shell
kubectl apply --server-side -f https://raw.githubusercontent.com/nginx/nginx-gateway-fabric/main/deploy/crds.yaml
```

### Deploy NGINX Gateway Fabric

{{< note >}} By default, NGINX Gateway Fabric is installed in the **nginx-gateway** namespace. You can deploy in another namespace by modifying the manifest files. {{< /note >}}

{{<tabs name="install-manifests">}}

{{%tab name="Default"%}}

Deploys NGINX Gateway Fabric with NGINX OSS.

```shell
kubectl apply -f https://raw.githubusercontent.com/nginx/nginx-gateway-fabric/v{{< version-ngf >}}/deploy/default/deploy.yaml
```

{{% /tab %}}

{{%tab name="AWS NLB"%}}

Deploys NGINX Gateway Fabric with NGINX OSS.

```shell
kubectl apply -f https://raw.githubusercontent.com/nginx/nginx-gateway-fabric/v{{< version-ngf >}}/deploy/default/deploy.yaml
```

To set up an AWS Network Load Balancer service, add these annotations to your Gateway infrastructure field:

```yaml
spec:
  infrastructure:
    annotations:
      service.beta.kubernetes.io/aws-load-balancer-type: "external"
      service.beta.kubernetes.io/aws-load-balancer-nlb-target-type: "ip"
```

{{% /tab %}}

{{%tab name="Azure"%}}

Deploys NGINX Gateway Fabric with NGINX OSS and `nodeSelector` to deploy on Linux nodes.

```shell
kubectl apply -f https://raw.githubusercontent.com/nginx/nginx-gateway-fabric/v{{< version-ngf >}}/deploy/azure/deploy.yaml
```

{{% /tab %}}

{{%tab name="NGINX Plus"%}}

Deploys NGINX Gateway Fabric with NGINX Plus. The image is pulled from the
NGINX Plus Docker registry, and the `imagePullSecretName` is the name of the Secret to use to pull the image.
The NGINX Plus JWT Secret used to run NGINX Plus is also specified in a volume mount and the `--usage-report-secret` parameter. These Secrets are created as part of the [Before you begin](#before-you-begin) section.

```shell
kubectl apply -f https://raw.githubusercontent.com/nginx/nginx-gateway-fabric/v{{< version-ngf >}}/deploy/nginx-plus/deploy.yaml
```

{{% /tab %}}

{{%tab name="Experimental"%}}

Deploys NGINX Gateway Fabric with NGINX OSS and experimental features.

```shell
kubectl apply -f https://raw.githubusercontent.com/nginx/nginx-gateway-fabric/v{{< version-ngf >}}/deploy/experimental/deploy.yaml
```

{{< note >}} Requires the Gateway APIs installed from the experimental channel. {{< /note >}}

{{% /tab %}}

{{%tab name="NGINX Plus Experimental"%}}

Deploys NGINX Gateway Fabric with NGINX Plus and experimental features. The image is pulled from the
NGINX Plus Docker registry, and the `imagePullSecretName` is the name of the Secret to use to pull the image.
The NGINX Plus JWT Secret used to run NGINX Plus is also specified in a volume mount and the `--usage-report-secret` parameter. These Secrets are created as part of the [Before you begin](#before-you-begin) section.

```shell
kubectl apply -f https://raw.githubusercontent.com/nginx/nginx-gateway-fabric/v{{< version-ngf >}}/deploy/nginx-plus-experimental/deploy.yaml
```

{{< note >}} Requires the Gateway APIs installed from the experimental channel. {{< /note >}}

{{% /tab %}}

{{%tab name="NodePort"%}}

Deploys NGINX Gateway Fabric with NGINX OSS using a Service type of `NodePort`.

```shell
kubectl apply -f https://raw.githubusercontent.com/nginx/nginx-gateway-fabric/v{{< version-ngf >}}/deploy/nodeport/deploy.yaml
```

{{% /tab %}}

{{%tab name="OpenShift"%}}

Deploys NGINX Gateway Fabric with NGINX OSS on OpenShift.

```shell
kubectl apply -f https://raw.githubusercontent.com/nginx/nginx-gateway-fabric/v{{< version-ngf >}}/deploy/openshift/deploy.yaml
```

{{% /tab %}}

{{</tabs>}}

### Verify the Deployment

To confirm that NGINX Gateway Fabric is running, check the pods in the `nginx-gateway` namespace:

```shell
kubectl get pods -n nginx-gateway
```

The output should look similar to this (note that the pod name will include a unique string):

```text
NAME                             READY   STATUS    RESTARTS   AGE
nginx-gateway-5d4f4c7db7-xk2kq   1/1     Running   0          112s
```

### Access NGINX Gateway Fabric

{{< include "/ngf/installation/expose-nginx-gateway-fabric.md" >}}

## Uninstall NGINX Gateway Fabric

Follow these steps to uninstall NGINX Gateway Fabric and Gateway API from your Kubernetes cluster:

1. **Uninstall NGINX Gateway Fabric:**

   - To remove NGINX Gateway Fabric and its custom resource definitions (CRDs), run:

     ```shell
     kubectl delete namespace nginx-gateway
     kubectl delete cluterrole nginx-gateway
     kubectl delete clusterrolebinding nginx-gateway
     ```

     ```shell
     kubectl delete -f https://raw.githubusercontent.com/nginx/nginx-gateway-fabric/v{{< version-ngf >}}/deploy/crds.yaml
     ```

1. **Remove the Gateway API resources:**

   - {{< include "/ngf/installation/uninstall-gateway-api-resources.md" >}}

## Next steps

- [Deploy a Gateway for data plane instances]({{< ref "/ngf/install/deploy-data-plane.md" >}})
- [Routing traffic to applications]({{< ref "/ngf/traffic-management/basic-routing.md" >}})