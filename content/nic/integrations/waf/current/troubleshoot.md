---
title: Troubleshoot the current F5 WAF for NGINX integration
linkTitle: "Troubleshoot"
description: Find and fix common problems with F5 WAF for NGINX in NGINX Ingress Controller, such as missing bundles and bundle source errors.
weight: 700
toc: true
f5-content-type: how-to
f5-product: F5 NGINX Ingress Controller
aliases:
  - /nginx-ingress-controller/integrations/app-protect-waf-v5/troubleshoot-app-protect-waf/
---

**Applies to:** Current F5 WAF for NGINX integration, all policy-management methods

This document describes how to troubleshoot problems when using NGINX Ingress Controller with F5 WAF for NGINX. For the legacy F5 WAF for NGINX integration, see [Troubleshoot the legacy F5 WAF for NGINX integration]({{< ref "/nic/integrations/waf/legacy/troubleshoot.md" >}}).

For general troubleshooting of NGINX Ingress Controller, check the general [troubleshooting]({{< ref "/nic/troubleshooting/troubleshoot-common" >}}) documentation. For Policy Lifecycle Management (PLM), see [Troubleshooting]({{< ref "/nic/integrations/waf/current/plm-installation.md#troubleshooting" >}}) in the PLM installation guide.

## Potential problems

The following table lists potential problems with NGINX Ingress Controller when the F5 WAF for NGINX module is turned on. It suggests how to troubleshoot them, using one or more methods from [Troubleshooting methods](#troubleshooting-methods).

{{< table >}}

|Problem area | Symptom | Troubleshooting method | Common cause |
| ---| ---| ---| --- |
|Start | The Ingress Controller fails to start. | Check the logs. | Misconfigured policy bundle. |
|Start | The configuration is not applied. | Check if a policy bundle is compiled using version of the compiler running in NGINX Ingress Controller. | Policy bundle is invalid. |
|Start | The configuration is not applied. | [Check that the bundle is in the bundle folder](#check-that-the-bundle-is-in-the-bundle-folder). | Policy bundle is not present in the bundle folder, `/etc/app_protect/bundles`. |
|Policy or Ingress Resource. | The configuration is not applied. | Check the events of the Policy and Ingress Resource, check the logs, replace the policy bundle. | Policy bundle is invalid. |
|[Bundle source]({{< ref "/nic/integrations/waf/current/bundle-sources.md" >}}). | Bundle not fetched, Warning event on Policy. | Check Policy events and status. Verify the bundle source URL and credentials are correct. | Invalid URL, authentication failure, or bundle not yet compiled on the management plane. |
|[Bundle source]({{< ref "/nic/integrations/waf/current/bundle-sources.md" >}}). | VirtualServer or Ingress returns HTTP 500. | Check Policy status for bundle source errors. | Bundle source is unreachable or the bundle is not yet available. |
|[Bundle source]({{< ref "/nic/integrations/waf/current/bundle-sources.md" >}}). | Policy not updating after bundle recompilation. | Verify ``enablePolling`` is ``true`` and ``pollInterval`` is at least ``1m``. | Polling is turned off, or the poll interval is less than the minimum. |

{{< /table >}}

## Troubleshooting methods

### Check NGINX Ingress Controller and F5 WAF for NGINX logs

{{< include "nic/waf/troubleshoot-check-logs.md" >}}

### Check Ingress resource events

Read the topic [Troubleshooting Ingress resources]({{< ref "/nic/troubleshooting/troubleshoot-ingress" >}}).

### Check that the bundle is in the bundle folder

When a Policy resource references a bundle that NGINX Ingress Controller can't find, NGINX Ingress Controller doesn't apply the Policy. It reports a warning on the VirtualServer, VirtualServerRoute, or Ingress resource that uses the Policy, and a VirtualServer that uses it returns HTTP 500. The warning shows the full path that NGINX Ingress Controller checked:

```text
WAF policy <NAMESPACE>/<POLICY_NAME> references an invalid or non-existing App Protect bundle <BUNDLE_PATH>
```

For a log bundle, the warning says `log config bundle` instead of `App Protect bundle`.

1. Check the events of the resource that uses the Policy. For example, for a VirtualServer:

    ```shell
    kubectl describe virtualserver <VIRTUALSERVER_NAME> --namespace <NAMESPACE>
    ```

1. Compare `<BUNDLE_PATH>` in the warning with the bundle folder for the current F5 WAF for NGINX integration, `/etc/app_protect/bundles/`.

    If the path starts with `/etc/nginx/waf/bundles/`, the pod runs the legacy F5 WAF for NGINX integration. To confirm, see [Check which integration you run]({{< ref "/nic/integrations/waf/choose-deployment.md#check-which-integration-you-run" >}}), then follow [Troubleshoot the legacy F5 WAF for NGINX integration]({{< ref "/nic/integrations/waf/legacy/troubleshoot.md" >}}).

1. List the files in the bundle folder:

    ```shell
    kubectl exec <POD_NAME> --namespace <NAMESPACE> --container <CONTAINER_NAME> -- ls -la /etc/app_protect/bundles
    ```

    Replace `<CONTAINER_NAME>` with `nginx-ingress` if you installed with Helm, or `nginx-plus-ingress` if you installed with manifests.

1. If the bundle isn't in the list, copy it to `/etc/app_protect/bundles/` with the file name that the Policy resource references. For an example, see [Install F5 WAF for NGINX with Helm and local bundles]({{< ref "/nic/integrations/waf/current/helm-local-bundles.md" >}}).

## Run F5 WAF for NGINX in debug mode

When you set NGINX Ingress Controller to use debug mode, the setting also applies to the F5 WAF for NGINX module. See [Running NGINX in the Debug Mode]({{< ref "/nic/troubleshooting/troubleshoot-common.md#enable-debugging-for-nginx-ingress-controller" >}}) for instructions.

## Known issues

### Subrequests compatibility

{{< include "nic/waf/troubleshoot-subrequests.md" >}}
