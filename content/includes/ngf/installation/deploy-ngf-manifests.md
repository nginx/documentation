---
nd-docs: "DOCS-000"
files:
- content/ngf/install/manifests.md
- content/nginx-one/ngf/add-ngf-manifests.md
---

{{< call-out "note" >}} By default, NGINX Gateway Fabric is installed in the **nginx-gateway** namespace. You can deploy in another namespace by modifying the manifest files. {{< /call-out >}}

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

{{< call-out "note" >}} Requires the Gateway APIs installed from the experimental channel. {{< /call-out >}}

{{% /tab %}}

{{%tab name="NGINX Plus Experimental"%}}

Deploys NGINX Gateway Fabric with NGINX Plus and experimental features. The image is pulled from the
NGINX Plus Docker registry, and the `imagePullSecretName` is the name of the Secret to use to pull the image.
The NGINX Plus JWT Secret used to run NGINX Plus is also specified in a volume mount and the `--usage-report-secret` parameter. These Secrets are created as part of the [Before you begin](#before-you-begin) section.

```shell
kubectl apply -f https://raw.githubusercontent.com/nginx/nginx-gateway-fabric/v{{< version-ngf >}}/deploy/nginx-plus-experimental/deploy.yaml
```

{{< call-out "note" >}} Requires the Gateway APIs installed from the experimental channel. {{< /call-out >}}

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

### Provision an NGINX data plane

To deploy the NGINX data plane to connect to the NGINX One Console, follow this guide: [Deploy a Gateway for data plane instances]({{< ref "/ngf/install/deploy-data-plane.md" >}}).

