---
title: Troubleshoot the legacy F5 WAF for NGINX integration
linkTitle: "Troubleshoot"
description: Find and fix common problems with the legacy F5 WAF for NGINX integration in NGINX Ingress Controller, such as invalid APPolicy resources and missing bundles.
weight: 300
toc: true
f5-content-type: how-to
f5-product: F5 NGINX Ingress Controller
---

**Applies to:** Legacy F5 WAF for NGINX integration, CRD-based (in-pod compilation) and bundle-based (local bundles)

This document describes how to troubleshoot problems when using NGINX Ingress Controller with the legacy F5 WAF for NGINX integration. For F5 WAF for NGINX, see [Troubleshoot the current F5 WAF for NGINX integration]({{< ref "/nic/integrations/waf/current/troubleshoot.md" >}}).

For general troubleshooting of NGINX Ingress Controller, check the general [troubleshooting]({{< ref "/nic/troubleshooting/troubleshoot-common" >}}) documentation.

## Potential problems

The following table lists potential problems with NGINX Ingress Controller when the legacy F5 WAF for NGINX integration is turned on. It suggests how to troubleshoot them, using one or more methods from [Troubleshooting methods](#troubleshooting-methods).

{{< table >}}

|Problem area | Symptom | Troubleshooting method | Common cause |
| ---| ---| ---| --- |
|Start | The Ingress Controller fails to start. | Check the logs. | Misconfigured `APLogConf` or `APPolicy` resource, or misconfigured policy bundle. |
|`APLogConf`, `APPolicy`, or Ingress resource | The configuration is not applied. | Check the events of the `APLogConf`, `APPolicy`, and Ingress resources, check the logs, and [replace the policy](#replace-the-policy). | `APLogConf` or `APPolicy` resource is invalid. |
|NGINX | NGINX Ingress Controller times out while it verifies NGINX at first start or during a reload after a change. | [Check the availability of APPolicy external references](#check-the-availability-of-appolicy-external-references). | Too many Ingress resources with F5 WAF for NGINX turned on. See [NGINX fails to start or reload](#nginx-fails-to-start-or-reload). |
|Start | The configuration is not applied. | Check if a policy bundle is compiled using the version of the compiler running in NGINX Ingress Controller. | Policy bundle is invalid. |
|Start | The configuration is not applied. | [Check that the bundle is in the bundle folder](#check-that-the-bundle-is-in-the-bundle-folder). | Policy bundle is not present in the bundle folder, `/etc/nginx/waf/bundles`. |

{{< /table >}}

## Troubleshooting methods

### Check NGINX Ingress Controller and F5 WAF for NGINX logs

{{< include "nic/waf/troubleshoot-check-logs.md" >}}

### Check Ingress resource events

Read the topic [Troubleshooting Ingress resources]({{< ref "/nic/troubleshooting/troubleshoot-ingress" >}}).

### Check APLogConf events

After you create or update an APLogConf, you can immediately check if the NGINX configuration was successfully applied by NGINX:

```shell
kubectl describe aplogconf logconf
Name:         logconf
Namespace:    default

Events:
  Type    Reason          Age   From                      Message
  ----    ------          ----  ----                      -------
  Normal  AddedOrUpdated  11s   nginx-ingress-controller  AppProtectLogConfig  default/logconf was added or updated
```

In the events section, a `Normal` event with the `AddedOrUpdated` reason shows that the configuration was successfully applied.

### Check APPolicy events

After you create or update an APPolicy, you can immediately check if the NGINX configuration was successfully applied by NGINX:

```shell
kubectl describe appolicy dataguard-alarm
Name:         dataguard-alarm
Namespace:    default

Events:
  Type    Reason          Age    From                      Message
  ----    ------          ----   ----                      -------
  Normal  AddedOrUpdated  2m25s  nginx-ingress-controller  AppProtectPolicy default/dataguard-alarm was added or updated
```

The events section has a *Normal* event with the *AddedOrUpdated reason*, indicating the policy was successfully accepted.

### Replace the policy

{{< call-out class="note" >}} This method only applies if using [external references](/nginx-app-protect/v4/configuration/#external-references) {{< /call-out >}}

If items on the external reference change but the spec of the APPolicy remains unchanged (even when re-applying the policy), Kubernetes will not detect the update.
In this case you can force-replace the resource. This will remove the resource and add it again, triggering a reload. For example:

```shell
kubectl replace appolicy -f your-policy-manifest.yaml --force
```

### Check the availability of APPolicy external references

{{< call-out class="note" >}} This method only applies if you're using [external references](/nginx-app-protect/v4/configuration/#external-references) in F5 WAF for NGINX policies. {{< /call-out >}}

To check which servers host the external references of a policy:

```shell
kubectl get appolicy mypolicy -o jsonpath='{.items[*].spec.policy.*.link}' | tr ' ' '\n'
http://192.168.100.100/resources/headersettings.txt
```

You can check the total time an HTTP request takes in multiple ways, for example, using curl:

```shell
curl -w '%{time_total}' http://192.168.100.100/resources/headersettings.txt
```

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

1. Compare `<BUNDLE_PATH>` in the warning with the bundle folder for the legacy F5 WAF for NGINX integration, `/etc/nginx/waf/bundles/`.

    If the path starts with `/etc/app_protect/bundles/`, the pod runs the current F5 WAF for NGINX integration, not the legacy integration. To confirm, see [Check which integration you run]({{< ref "/nic/integrations/waf/choose-deployment.md#check-which-integration-you-run" >}}), then follow [Troubleshoot the current F5 WAF for NGINX integration]({{< ref "/nic/integrations/waf/current/troubleshoot.md" >}}).

1. List the files in the bundle folder:

    ```shell
    kubectl exec <POD_NAME> --namespace <NAMESPACE> --container <CONTAINER_NAME> -- ls -la /etc/nginx/waf/bundles
    ```

    Replace `<CONTAINER_NAME>` with `nginx-ingress` if you installed with Helm, or `nginx-plus-ingress` if you installed with manifests.

1. If the bundle isn't in the list, copy it to `/etc/nginx/waf/bundles/` with the file name that the Policy resource references. The folder must be on a volume that you mount. For details, see [Deploy NGINX Ingress Controller]({{< ref "/nic/integrations/waf/legacy/installation.md#deploy-ingress-controller" >}}).

## Run F5 WAF for NGINX in debug mode

When you set NGINX Ingress Controller to use debug mode, the setting also applies to the F5 WAF for NGINX module. See [Running NGINX in the Debug Mode]({{< ref "/nic/troubleshooting/troubleshoot-common.md#enable-debugging-for-nginx-ingress-controller" >}}) for instructions.

## Known issues

Users have reported the following issues when they use NGINX Ingress Controller with the legacy F5 WAF for NGINX integration. These issues commonly occur when a cluster has many Ingress resources with F5 WAF for NGINX turned on.

### Subrequests compatibility

{{< include "nic/waf/troubleshoot-subrequests.md" >}}

### NGINX configuration drift

When you make a change that requires NGINX to apply a new configuration, NGINX Ingress Controller reloads NGINX automatically. Without the F5 WAF for NGINX module turned on, typical reload times are around 150ms. If the F5 WAF for NGINX module is turned on and is being used by any number of Ingress resources, these reloads might take a few seconds instead.

If you are running more than one instance of NGINX Ingress Controller, the extended reload time may cause the NGINX configuration of your instances to be out of sync. This can occur because there is no order imposed on how NGINX Ingress Controller processes the Kubernetes resources. The configurations will be the same after all instances have completed the reload.

To reduce these inconsistencies, don't apply changes to multiple resources handled by NGINX Ingress Controller at the same time.

### NGINX fails to start or reload

The first time NGINX Ingress Controller starts, or whenever there is a change that requires reloading NGINX, NGINX Ingress Controller verifies that the reload was successful. The timeout for this verification is typically 4 seconds. When F5 WAF for NGINX is turned on, this timeout increases to 20 seconds.

This timeout is typically enough to verify configurations. However, when NGINX Ingress Controller handles many Ingress resources with F5 WAF for NGINX turned on at the same time, you might need to extend the timeout further. For example:

- You need to apply a large number of Ingress resources at once.
- You are running NGINX Ingress Controller for the first time in a cluster where Ingress resources with F5 WAF for NGINX turned on are already present.

You can increase this timeout by setting the `nginx-reload-timeout` [command-line argument]({{< ref "/nic/configuration/global-configuration/command-line-arguments.md#cmdoption-nginx-reload-timeout" >}}).

When using the User Defined Signature feature, an update to an `APUserSig` requires more reload time from NGINX Plus compared with the other F5 WAF for NGINX resources. As a consequence, F5 recommends increasing the `nginx-reload-timeout` to 30 seconds if you're planning to use this feature.

If you are using external references in your F5 WAF for NGINX policies, verify if the servers hosting the referenced resources are available and that their response time is as short as possible. For details, see [Check the availability of APPolicy external references](#check-the-availability-of-appolicy-external-references). If the references are not available during NGINX Ingress Controller startup, the pod will fail to start. In case the resources are not available during a reload, the reload will fail, and NGINX Plus will use the previous correct configuration.
