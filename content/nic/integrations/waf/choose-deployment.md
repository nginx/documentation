---
title: Choose an F5 WAF for NGINX deployment
linkTitle: "Choose a deployment"
description: "Compare the two ways NGINX Ingress Controller integrates F5 WAF for NGINX, the policy-management methods, and how to check which integration you run."
weight: 100
toc: true
f5-content-type: concept
f5-product: F5 NGINX Ingress Controller
f5-keywords: "F5 WAF for NGINX, current integration, legacy integration, NGINX Ingress Controller, WAF integration, policy management, Policy Lifecycle Management, PLM, in-pod compilation, bundle sources, local bundles, bundle folder, apPolicy, apBundle, apBundleSource"
f5-summary: >
  An F5 WAF for NGINX deployment in NGINX Ingress Controller combines two independent choices: how NGINX Ingress Controller integrates F5 WAF for NGINX in the pod, and the policy-management method that delivers compiled policies to it.
  Together, they decide which image, Helm values, bundle folder, and guides apply to you.
  This page compares the options, lists the supported combinations, and shows how to check which integration you run.
f5-audience: operator
---

Two choices shape how F5 WAF for NGINX works with F5 NGINX Ingress Controller: the integration and the policy-management method. Together, they decide which image, Helm values, bundle folder, and guides apply to you.

## What is an F5 WAF for NGINX deployment

Every deployment makes two choices:

- **Integration**: How NGINX Ingress Controller runs F5 WAF for NGINX in the pod. There's a current integration and a legacy integration. Only the integration is legacy, not F5 WAF for NGINX.
- **Policy-management method**: How a compiled policy gets to the pod.

Older versions of these guides used v4 and v5 to describe both choices at once. Don't rely on that. For example, Policy Lifecycle Management (PLM) uses Kubernetes resources for policies, but it runs only on the current integration.

### Integration

Each NGINX Ingress Controller deployment uses one integration. NGINX Ingress Controller detects the integration from the image, not from a setting.

{{< table >}}

| | Current integration | Legacy integration |
| --- | --- | --- |
| Formerly | F5 WAF for NGINX v5 | F5 WAF for NGINX v4 |
| Status | Recommended | Supported, but not recommended for new deployments |
| What runs in the pod | The `nginx-ingress` container, plus the `waf-enforcer` and `waf-config-mgr` containers. When you turn on IP intelligence, the `waf-ip-intelligence` container also runs. | The `nginx-ingress` container, which includes the WAF engine and the policy compiler |
| Image in the F5 registry | `nginx-ic-nap-v5/nginx-plus-ingress` | `nginx-ic-nap/nginx-plus-ingress` |
| Bundle folder | `/etc/app_protect/bundles/`, on the `app-protect-bundles` volume | `/etc/nginx/waf/bundles/`, on a volume that you mount |
| Helm values | `controller.appprotect.enable=true` and `controller.appprotect.v5=true` | `controller.appprotect.enable=true` and `controller.appprotect.v5=false` |
| Guides | [Current integration guides]({{< ref "/nic/integrations/waf/current/" >}}) | [Legacy integration guides]({{< ref "/nic/integrations/waf/legacy/" >}}) |

{{< /table >}}

The `controller.appprotect.v5` Helm value doesn't choose the integration. It adds the `waf-enforcer` and `waf-config-mgr` containers and the `app-protect-bundles` volume. Set it to match your image, because the Helm chart can't check that they match.

### Policy management

Each NGINX Ingress Controller Policy resource chooses one way to get its policy. The methods fall into two groups:

- **CRD-based**: You define the policy in the cluster as `APPolicy`, `APLogConf`, and `APUserSig` custom resources. The group takes its name from the custom resource definitions (CRDs) behind these resources.
- **Bundle-based**: You compile the policy outside NGINX Ingress Controller. NGINX Ingress Controller receives the compiled `.tgz` bundle.

For CRD-based policies, the `-plm-storage-url` command-line argument sets the method for the whole deployment. If you set it, NGINX Ingress Controller uses PLM. If you don't, it uses in-pod compilation. The Helm chart sets this argument from `controller.appprotect.plmStorage.url`.

{{< table >}}

| Group | Method | Policy fields | Who compiles the policy | How the policy reaches the pod |
| --- | --- | --- | --- | --- |
| CRD-based | Policy Lifecycle Management (PLM) | `apPolicy` and `securityLogs[].apLogConf`, which name `appprotect.f5.com/v1` resources | The F5 WAF Policy Controller, which the PLM Helm chart installs | NGINX Ingress Controller downloads the bundles from PLM storage. |
| CRD-based | In-pod compilation | `apPolicy` and `securityLogs[].apLogConf`, which name `appprotect.f5.com/v1beta1` resources. The `appprotect.f5.com/app-protect-policy` and `appprotect.f5.com/app-protect-security-log` Ingress annotations also use this method. | The compiler in the `nginx-ingress` container | NGINX Ingress Controller writes each resource's `spec` to files in the pod, where the compiler compiles them. |
| Bundle-based | Bundle sources | `apBundleSource` and `securityLogs[].apLogBundleSource` | NGINX One Console, NGINX Instance Manager, or your own pipeline | NGINX Ingress Controller downloads the bundle from NGINX One Console, NGINX Instance Manager, or an HTTPS server. It can poll for updates. |
| Bundle-based | Local bundles | `apBundle` and `securityLogs[].apLogBundle` | You, with the F5 WAF compiler, NGINX Instance Manager, or NGINX One Console | You copy the `.tgz` file into the bundle folder. |

{{< /table >}}

### Supported combinations

{{< table >}}

| Method | Current integration | Legacy integration |
| --- | --- | --- |
| Policy Lifecycle Management (PLM) | Supported | Not supported |
| In-pod compilation | Not supported | Supported |
| Bundle sources | Supported | Not supported |
| Local bundles | Supported | Supported |

{{< /table >}}

### Key terms

These guides use the following terms:

- **NGINX Ingress Controller Policy resource**: A `k8s.nginx.org/v1` `Policy` resource with a `spec.waf` section.
- **APPolicy resource**: An `appprotect.f5.com` `APPolicy` custom resource.
- **Policy bundle** and **log bundle**: Compiled `.tgz` files that hold a security policy or a logging profile.
- **Logging profile**: The contents of an `APLogConf` resource or a log bundle.
- **Bundle folder**: The directory that NGINX Ingress Controller reads bundles from. It depends on the integration.
- **Policy Lifecycle Management (PLM)**: The feature that compiles `APPolicy` and `APLogConf` resources outside NGINX Ingress Controller. The F5 WAF Policy Controller, which the PLM Helm chart installs, does the compiling.

## Former names

Older versions of these guides used version numbers for the integrations and other names for the product. Use this table to find the current name.

{{< table >}}

| Former name | Current name |
| --- | --- |
| F5 WAF for NGINX v5, NAP v5, WAF v5 | Current F5 WAF for NGINX integration |
| F5 WAF for NGINX v4, NAP v4, package-based installation | Legacy integration |
| F5 WAF for NGINX, as the name of the section for the v4 integration | Legacy integration |
| NGINX App Protect WAF, App Protect, NAP | F5 WAF for NGINX |
| Kubernetes operations improvements (early access) | Policy Lifecycle Management (PLM) |

{{< /table >}}

Older guides also used CRD-based to mean v4 and bundle-based to mean v5. Both terms now describe policy management only. CRD-based covers PLM and in-pod compilation. Bundle-based covers bundle sources and local bundles.

Some literal names keep the former names. For example, the `controller.appprotect.v5` Helm value, the `nginx-ic-nap-v5` image, and Makefile targets such as `debian-image-nap-v5-plus` refer to the current F5 WAF for NGINX integration. Names such as `appprotect.f5.com`, `-enable-app-protect`, and the `app_protect_*` NGINX directives apply to both integrations.

## Use cases

### Start a new deployment

A platform team adds WAF protection to a new cluster. They use the current integration, which F5 recommends. Then they choose a policy-management method:

- To define policies as Kubernetes resources, they use PLM.
- If their security team manages policies in NGINX One Console or NGINX Instance Manager, they use bundle sources.
- If they compile policies in their own pipeline, they host the bundles on an HTTPS server as a bundle source, or copy them to the pod as local bundles.

### Keep a legacy deployment running

An operator runs the `nginx-ic-nap` image and defines policies as `APPolicy` resources. Their deployment runs the legacy F5 WAF for NGINX integration with in-pod compilation, so they follow the legacy integration guides. When they're ready to move, they follow [Migrate from in-pod compilation to Policy Lifecycle Management]({{< ref "/nic/integrations/waf/legacy/migrate/plm.md" >}}). Their `APPolicy` resources keep working under PLM.

### Copy a bundle to the right folder

An operator copies a compiled policy bundle into the pod, but NGINX Ingress Controller reports that the bundle doesn't exist. The bundle folder depends on the integration. The operator [checks which integration the pod uses](#check-which-integration-you-run), then copies the bundle to the bundle folder for that integration.

## Check which integration you run

NGINX Ingress Controller decides the integration from a marker file, `/opt/app_protect/VERSION.common`. Only legacy images include this file.

1. Check whether the pod has the marker file:

    ```shell
    kubectl exec <POD_NAME> --namespace <NAMESPACE> --container <CONTAINER_NAME> -- ls /opt/app_protect/VERSION.common
    ```

    Replace the placeholders as follows:

    - `<POD_NAME>`: The name of an NGINX Ingress Controller pod.
    - `<NAMESPACE>`: The namespace of the pod.
    - `<CONTAINER_NAME>`: `nginx-ingress` if you installed with Helm, or `nginx-plus-ingress` if you installed with manifests. If you set `nameOverride` in your Helm values, use that value.

1. Read the result:

    - If the command prints `/opt/app_protect/VERSION.common`, the pod runs the legacy F5 WAF for NGINX integration.
    - If the command reports `No such file or directory`, the pod runs the current F5 WAF for NGINX integration.

1. List the containers in the pod to check that they match the integration:

    ```shell
    kubectl get pod <POD_NAME> --namespace <NAMESPACE> --output jsonpath='{.spec.containers[*].name}'
    ```

    Pods that run the current integration include the `waf-enforcer` and `waf-config-mgr` containers. Legacy pods don't. If the containers don't match the result of step 2, the `controller.appprotect.v5` Helm value doesn't match the image. Set it to `true` for images for the current integration and `false` for legacy images.

If you pull images from the F5 registry, the image name also shows the integration. `nginx-ic-nap-v5/nginx-plus-ingress` is the current F5 WAF for NGINX integration, and `nginx-ic-nap/nginx-plus-ingress` is the legacy F5 WAF for NGINX integration.

## References

For more information, see:

- [Current integration guides]({{< ref "/nic/integrations/waf/current/" >}})
- [Legacy integration guides]({{< ref "/nic/integrations/waf/legacy/" >}})
- [WAF fields in the Policy resource reference]({{< ref "/nic/configuration/policy-resource/policy-reference.md#waf" >}})
- [Kubernetes Policy Lifecycle Management in the F5 WAF for NGINX documentation]({{< ref "/waf/install/kubernetes-plm.md" >}})
- [Build and use the F5 WAF for NGINX compiler tool]({{< ref "/waf/configure/compiler.md" >}})
