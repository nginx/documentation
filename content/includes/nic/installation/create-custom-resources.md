---
nd-docs: DOCS-1463
---

To make sure your NGINX Ingress Controller pods reach the `Ready` state, you'll need to create custom resource definitions (CRDs) for various components.

Alternatively, you can disable this requirement by setting the `-enable-custom-resources` command-line argument to `false`.

There are two ways you can install the custom resource definitions:

1. Using a URL to apply a single CRD yaml file, which we recommend.
1. Applying your local copy of the CRD yaml files, which requires you to clone the repository.

The core custom CRDs are the following:

- [VirtualServer and VirtualServerRoute]({{< ref "/nic/configuration/virtualserver-and-virtualserverroute-resources.md" >}})
- [TransportServer]({{< ref "/nic/configuration/transportserver-resource.md" >}})
- [Policy]({{< ref "/nic/configuration/policy-resource.md" >}})
- [GlobalConfiguration]({{< ref "/nic/configuration/global-configuration/globalconfiguration-resource.md" >}})

{{<tabs name="install-crds">}}

{{%tab name="Install CRDs from single YAML"%}}

```shell
kubectl apply -f https://raw.githubusercontent.com/nginx/kubernetes-ingress/v{{< nic-version >}}/deploy/crds.yaml
```

{{%/tab%}}

{{%tab name="Install CRDs after cloning the repo"%}}

{{< call-out "note" >}} 

Read the steps outlined in [Upgrade from 3.x to 4.x]({{< ref "/nic/installation/upgrade-version.md#upgrade-from-3x-to-4x" >}}) before running the CRD upgrade and perform the steps if applicable.

{{< /call-out >}}


```shell
kubectl apply -f config/crd/bases/k8s.nginx.org_virtualservers.yaml
kubectl apply -f config/crd/bases/k8s.nginx.org_virtualserverroutes.yaml
kubectl apply -f config/crd/bases/k8s.nginx.org_transportservers.yaml
kubectl apply -f config/crd/bases/k8s.nginx.org_policies.yaml
kubectl apply -f config/crd/bases/k8s.nginx.org_globalconfigurations.yaml
```

{{%/tab%}}

{{</tabs>}}
