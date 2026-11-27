---
title: Migrate local bundles to the current integration
linkTitle: "From local bundles"
description: Move an NGINX Ingress Controller deployment that uses local policy bundles from the legacy F5 WAF for NGINX integration to the current integration.
weight: 200
toc: true
f5-content-type: how-to
f5-product: F5 NGINX Ingress Controller
f5-keywords: "F5 WAF for NGINX, legacy integration, multi-container integration, migrate, local bundles, apBundle, apLogBundle, bundle folder, waf-compiler, controller.appprotect.v5, nginx-ic-nap-v5"
f5-summary: >
  Move an NGINX Ingress Controller deployment that uses local policy bundles from the legacy F5 WAF for NGINX integration to the current integration.
  You recompile your bundles, switch the image and Helm values, and copy the bundles to the new bundle folder.
  This guide covers Helm installations, and your Policy resources don't change.
f5-audience: operator
---

**Applies to:** From the legacy F5 WAF for NGINX integration, bundle-based (local bundles), to the current integration, bundle-based (local bundles)

## Overview

Use this guide to move an F5 NGINX Ingress Controller deployment that uses local policy bundles from the legacy F5 WAF for NGINX integration to the current integration. You recompile your bundles, switch the image and Helm values, and then copy the bundles to the new bundle folder.

Your NGINX Ingress Controller Policy resources don't change. The `apBundle` and `apLogBundle` fields name bundle files. NGINX Ingress Controller looks for those files in the bundle folder for the integration that it uses:

{{< table >}}

| Integration | Bundle folder |
| --- | --- |
| Legacy integration | `/etc/nginx/waf/bundles/` |
| Current integration | `/etc/app_protect/bundles/` |

{{< /table >}}

{{< call-out class="caution" >}} Until a bundle is in the new bundle folder, NGINX Ingress Controller doesn't apply the Policy resources that reference it. A VirtualServer that uses one of these Policy resources returns HTTP 500. Plan a maintenance window, or test these steps in a non-production cluster first. {{< /call-out >}}

To stop copying bundles by hand after the migration, see [Fetch policy bundles from a remote source]({{< ref "/nic/integrations/waf/current/bundle-sources.md" >}}).

## Before you begin

Before you begin, make sure you have:

- **An NGINX Ingress Controller deployment that runs the legacy F5 WAF for NGINX integration with local bundles**: This guide covers deployments that you installed with Helm. To confirm the integration, see [Check which integration you run]({{< ref "/nic/integrations/waf/choose-deployment.md#check-which-integration-you-run" >}}).
- **The JSON source files for your policies and logging profiles**: You need them to recompile your bundles. If you compile bundles with NGINX Instance Manager, you need access to NGINX Instance Manager instead.
- **Credentials for `private-registry.nginx.com`**: You need them to pull the F5 WAF for NGINX images.
- **The `kubectl`, `helm`, and `docker` command-line tools**: You use them to run the commands in this guide.

If you installed NGINX Ingress Controller with manifests, follow the **With Manifest** steps in [Build NGINX Ingress Controller for the current F5 WAF for NGINX integration]({{< ref "/nic/integrations/waf/current/installation.md#deploy-ingress-controller" >}}) instead of [Switch NGINX Ingress Controller to the current integration](#switch-nginx-ingress-controller-to-the-current-integration).

## Recompile your bundles

F5 WAF for NGINX loads only bundles that match its compiler version, so bundles that you compiled for the legacy F5 WAF for NGINX integration don't work. Recompile each policy bundle and log bundle.

Find the F5 WAF for NGINX version for your NGINX Ingress Controller release. The compiler image uses the same version as the Enforcer.

{{< include "nic/compatibility-tables/nic-nap.md" >}}

To compile bundles with the F5 WAF for NGINX compiler image:

1. Pull the compiler image. This command uses the version for NGINX Ingress Controller {{< nic-version >}}. For other releases, use the Enforcer version from the table.

    ```shell
    docker pull private-registry.nginx.com/nap/waf-compiler:{{< nic-waf-release-version >}}
    ```

1. Compile each policy. Use the file name that your Policy resource references in `apBundle`:

    ```shell
    docker run --rm \
        -v $(pwd):$(pwd) \
        private-registry.nginx.com/nap/waf-compiler:{{< nic-waf-release-version >}} \
        -p $(pwd)/<POLICY_FILE>.json \
        -o $(pwd)/<BUNDLE_NAME>.tgz
    ```

    Replace `<POLICY_FILE>` with the name of your policy JSON file and `<BUNDLE_NAME>` with the bundle name from `apBundle`.

1. Compile each logging profile. Use the file name that your Policy resource references in `apLogBundle`:

    ```shell
    docker run --rm \
        -v $(pwd):$(pwd) \
        private-registry.nginx.com/nap/waf-compiler:{{< nic-waf-release-version >}} \
        -l $(pwd)/<LOG_PROFILE_FILE>.json \
        -o $(pwd)/<LOG_BUNDLE_NAME>.tgz
    ```

    Replace `<LOG_PROFILE_FILE>` with the name of your logging profile JSON file and `<LOG_BUNDLE_NAME>` with the bundle name from `apLogBundle`.

The compiler runs as user ID 101, so that user must be able to read your input files and write to the output folder. If you use more than one policy bundle, compile them with the same global settings file. For details, see [Build and use the compiler tool]({{< ref "/waf/configure/compiler.md#using-the-compiler" >}}).

If you compile bundles with NGINX Instance Manager, create new bundles for the F5 WAF for NGINX compiler version. For the steps, see [Compile policy bundles with NGINX Instance Manager]({{< ref "/nic/integrations/waf/current/compile-waf-policies.md" >}}).

## Switch NGINX Ingress Controller to the current integration

Upgrade the Helm release with the F5 WAF for NGINX image, and set `controller.appprotect.v5` to `true`. This setting adds the `waf-enforcer` and `waf-config-mgr` containers and the `app-protect-bundles` volume. The chart mounts the volume at `/etc/app_protect/bundles` for you.

`--reuse-values` keeps your existing configuration. This example stores bundles on a PersistentVolumeClaim, so they persist across pod restarts:

```shell
helm upgrade <RELEASE_NAME> nginx-stable/nginx-ingress \
  --namespace <NAMESPACE> \
  --reuse-values \
  --set controller.image.repository="private-registry.nginx.com/nginx-ic-nap-v5/nginx-plus-ingress" \
  --set controller.image.tag="{{< nic-version >}}" \
  --set controller.appprotect.enable=true \
  --set controller.appprotect.v5=true \
  --set-json 'controller.appprotect.volumes=[
     {"name":"app-protect-bd-config","emptyDir":{}},
     {"name":"app-protect-config","emptyDir":{}},
     {"name":"app-protect-bundles","persistentVolumeClaim":{"claimName":"<CLAIM_NAME>"}}
  ]'
```

Replace the placeholders as follows:

- `<RELEASE_NAME>`: The name of your NGINX Ingress Controller Helm release.
- `<NAMESPACE>`: The namespace of the release.
- `<CLAIM_NAME>`: The PersistentVolumeClaim for the bundle folder. To use temporary storage instead, leave out the `--set-json` flag. The chart then uses `emptyDir` volumes, and bundles don't persist across pod restarts.

If your Helm values mount a volume at `/etc/nginx/waf/bundles` through `controller.volumes` and `controller.volumeMounts`, F5 WAF for NGINX doesn't read it. You can remove those entries after the migration.

Check that the new pods are running. Each pod runs the `nginx-ingress`, `waf-enforcer`, and `waf-config-mgr` containers:

```shell
kubectl get pods --namespace <NAMESPACE>
```

## Copy the bundles to the new bundle folder

1. Copy each policy bundle and log bundle to `/etc/app_protect/bundles` in the `nginx-ingress` container. Keep the file names that your Policy resources reference:

    ```shell
    kubectl cp <BUNDLE_NAME>.tgz \
        <NAMESPACE>/<POD_NAME>:/etc/app_protect/bundles/<BUNDLE_NAME>.tgz \
        -c nginx-ingress
    ```

    Replace `<POD_NAME>` with the name of an NGINX Ingress Controller pod. Repeat the command for each pod, unless the pods share the bundle volume.

1. Confirm that the bundles are in the bundle folder:

    ```shell
    kubectl exec <POD_NAME> --namespace <NAMESPACE> -c nginx-ingress -- ls -la /etc/app_protect/bundles
    ```

## Verify the migration

1. Check the events of each VirtualServer that uses a WAF policy:

    ```shell
    kubectl describe virtualserver <VIRTUALSERVER_NAME> --namespace <NAMESPACE>
    ```

    If an event reports an invalid or non-existing bundle in `/etc/app_protect/bundles/`, see [Troubleshooting](#troubleshooting).

1. Send a normal request and a request with an attack payload, as shown in [Install F5 WAF for NGINX with Helm and local bundles]({{< ref "/nic/integrations/waf/current/helm-local-bundles.md#confirm-that-the-waf-policies-work" >}}). The normal request succeeds, and F5 WAF for NGINX rejects the attack.

## Troubleshooting

### A VirtualServer returns HTTP 500 after the upgrade

**Symptom**: Requests to a VirtualServer that uses a WAF policy return HTTP 500. The VirtualServer events show a warning that a bundle is invalid or doesn't exist.

**Cause**: The bundle isn't in `/etc/app_protect/bundles`, its file name doesn't match the Policy resource, or a compiler for a different version compiled it.

**Fix**: Copy the bundle to `/etc/app_protect/bundles` with the file name from the Policy resource. If the bundle is there, recompile it with the compiler version for your release. For more checks, see [Check that the bundle is in the bundle folder]({{< ref "/nic/integrations/waf/current/troubleshoot.md#check-that-the-bundle-is-in-the-bundle-folder" >}}).

## References

For more information, see:

- [Choose an F5 WAF for NGINX deployment]({{< ref "/nic/integrations/waf/choose-deployment.md" >}})
- [Use local policy bundles with F5 WAF for NGINX]({{< ref "/nic/integrations/waf/current/local-bundles.md" >}})
- [Install F5 WAF for NGINX with Helm and local bundles]({{< ref "/nic/integrations/waf/current/helm-local-bundles.md" >}})
- [Migrate from in-pod compilation to Policy Lifecycle Management]({{< ref "/nic/integrations/waf/legacy/migrate/plm.md" >}})
- [Build and use the compiler tool]({{< ref "/waf/configure/compiler.md" >}})
