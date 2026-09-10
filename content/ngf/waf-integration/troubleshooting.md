---
title: Troubleshoot WAFPolicy status
weight: 500
toc: true
f5-content-type: reference
f5-product: NGINX Gateway Fabric
f5-description: Status condition reference and common issues for WAFPolicy in NGINX Gateway Fabric.
---

Use `kubectl describe wafpolicy <CONDITION_NAME>` to inspect status conditions. This page documents all condition types, reasons, and common troubleshooting steps.

---

## Condition reference

### Accepted

| Status  | Reason             | Meaning                                                                     |
|---------|--------------------|-----------------------------------------------------------------------------|
| `True`  | `Accepted`         | Policy is valid and targets a known resource                                |
| `False` | `Invalid`          | Policy spec fails validation (for example, wrong source field for the type) |
| `False` | `TargetNotFound`   | The targeted Gateway or Route does not exist                                |
| `False` | `Conflicted`       | Another `WAFPolicy` already targets this resource at the same level, or two `WAFPolicy` resources that share an upstream bundle use different polling settings |
| `False` | `NginxProxyNotSet` | WAF is not enabled in the referenced NginxProxy                             |

### ResolvedRefs

| Status  | Reason             | Meaning                                                                |
|---------|--------------------|--------------------------------------------------------------------------|
| `True`  | `ResolvedRefs`     | All referenced Secrets, `APPolicy`, and `APLogConf` resources resolved successfully |
| `False` | `InvalidRef`       | A referenced Secret was not found or is missing expected keys; or a referenced `APPolicy`/`APLogConf` doesn't exist |
| `False` | `RefNotPermitted`  | A referenced `APPolicy` or `APLogConf` is in a different namespace and no `ReferenceGrant` permits the reference |

### Programmed

| Status  | Reason               | Meaning                                                                          |
|---------|----------------------|----------------------------------------------------------------------------------|
| `True`  | `Programmed`         | Bundle fetched and deployed to the data plane                                    |
| `True`  | `BundleUpdated`      | A poll cycle detected a changed bundle and deployed it                           |
| `True`  | `StaleBundleWarning` | A poll cycle failed; previously deployed bundle remains active                   |
| `False` | `FetchError`         | Bundle could not be fetched (network error, HTTP error, auth failure, timeout)   |
| `False` | `IntegrityError`     | Bundle checksum verification failed                                              |
| `False` | `Pending`            | Bundle has never been fetched; configuration withheld or WAF omitted (fail-open) |

---

## Common issues

### `FetchError` with HTTP 403

The credentials Secret is either missing, contains the wrong keys, or the credentials are invalid. Verify the Secret exists in the same namespace as the `WAFPolicy` and that the keys match the authentication method (`username`/`password` for Basic Auth, `token` for Bearer/APIToken).

### `FetchError` with HTTP 404 on NGINX Instance Manager or NGINX One Console

The referenced policy was not found or has not been compiled yet. For NGINX Instance Manager, verify that compilation succeeded in the NGINX Instance Manager console before creating the `WAFPolicy`. For NGINX One Console, NGINX Gateway Fabric triggers compilation if no bundle exists, and a 404 after initial setup may indicate the policy was deleted in NGINX One Console.

### `Pending`

The bundle has never been successfully fetched. If `bundleFailOpen` is `false` (the default), the NGINX configuration push is withheld for this Gateway. If `bundleFailOpen` is `true`, traffic flows without WAF protection.

Check the `Programmed` condition message for the last fetch error. Common causes include network connectivity issues, incorrect URLs, or authentication failures. Verify the policy source URL and credentials Secret.

### `IntegrityError`

The downloaded bundle does not match the expected checksum. For HTTP source, ensure the `.sha256` file matches the bundle file. For `expectedChecksum`, verify the digest matches the bundle you intend to deploy.

### Policy not applied to a route

The route does not show a `gateway.nginx.org/WAFPolicyAffected` condition. Verify that:

- The `WAFPolicy` `targetRefs` field matches the Gateway or Route name and namespace.
- The Gateway has `waf.enable: true` in its referenced `NginxProxy`.
- The `WAFPolicy` `Accepted` condition is `True`.

### WAF sidecars not starting

Verify that the `waf-enforcer` and `waf-config-mgr` container images are accessible from your cluster, and that any required `imagePullSecrets` are configured in the `NginxProxy` Kubernetes spec.

### Duplicate policy name error

In NGINX Gateway Fabric 2.7.0 and later, bundle names are derived from the upstream source identity — the policy or log-profile source URL and its identifier — not from the `WAFPolicy` namespace and name. `WAFPolicy` resources that reference the same upstream bundle are deduplicated to a single bundle, including `WAFPolicy` resources in different namespaces, each targeting its own route that is itself attached to a shared Gateway. Deduplication is automatic, with nothing to enable. As a result, the `Duplicate policy name found` and `Duplicate logging profile name found` reload failures no longer occur.

Both errors can still occur for genuinely distinct upstream bundles whose compiled definitions embed the same logical policy or log-profile name. When two `WAFPolicy` resources in the same Gateway reference different compiled bundles that were compiled under the **same policy name**, the WAF engine rejects the configuration with an error like:

```text
"error_message": "Duplicate policy name found: <PolicyName>"
```

The WAF engine identifies policies and logging profiles by the logical name embedded in the compiled bundle — not the Kubernetes resource name or bundle filename. When the same logical name appears more than once in a single NGINX configuration, the configuration test fails and the update is rolled back.

**How to identify the problem:**

Check the NGINX Gateway Fabric controller logs for a configuration error containing `Duplicate policy name found` or `Duplicate logging profile name found`:

```shell
kubectl logs -n nginx-gateway deploy/<NGF_DEPLOYMENT_NAME> -c nginx-gateway | grep -E "Duplicate (policy|logging profile) name"
```

This step reads the logs of the NGINX Gateway Fabric controller Deployment, not the `WAFPolicy` resource, so it may require namespace-level log access; a reader without it may need a cluster administrator's help.

The Deployment name depends on your install method. For a Helm install it is `<release-name>-nginx-gateway-fabric`; run `kubectl get deploy -n nginx-gateway` to find it.

**Resolution:**

This applies only to distinct bundles that embed the same logical name. The same-logical-name rule applies to the `name` field set inside the compiled policy definition and inside the compiled log profile definition at compile time, not the `WAFPolicy` resource name or the bundle filename. Each such bundle must carry a unique logical name.

To resolve the conflict, choose one of the following approaches:

- **Recompile with a distinct name**: Update the policy definition or log profile definition to use a unique `name` field, then recompile and republish the bundle.
- **Consolidate to a single gateway-level policy**: If the intent is to apply the same policy everywhere, use a single gateway-level `WAFPolicy` instead of multiple route-level policies referencing different versions of the same named policy.
- **Audit for overlapping `WAFPolicies`**: The logical name lives inside the compiled bundle and is not shown in `kubectl get wafpolicies -A` output, so the list alone does not reveal the collision. List the WAFPolicies with `kubectl get wafpolicies -A`, then cross-check each one's source — the bundle URL, policy name, or object ID it points at, or the compiled definition in your NGINX Instance Manager or NGINX One Console records — for a shared logical policy or log profile name.

After recompiling and republishing with distinct names, confirm the fix by re-checking the controller logs to verify the error no longer appears, or by watching the affected `WAFPolicy`'s `Programmed` condition reach `True` with `kubectl describe wafpolicy <NAME>`.

### `WAFPolicy` marked `Conflicted` for mismatched polling settings

When two or more `WAFPolicy` resources resolve to the same upstream bundle but differ in polling settings — for example, one sets `polling.enabled: true` and another does not — NGINX Gateway Fabric accepts one and sets the `Accepted` condition to `False` on the rest, with reason `Conflicted`, until their polling settings agree.

**How to identify the problem:**

Run `kubectl describe wafpolicy <NAME>` and read the `Accepted` condition message. For a rejected policy, it reads:

```text
Conflicts with WAFPolicy <ns>/<name>: policy bundles share the same upstream identity but differ in polling configuration
```

For policies that share a log source, the equivalent message reads `security log bundles` in place of `policy bundles`.

**Resolution:**

Give every `WAFPolicy` that shares an upstream bundle the same [`polling` settings]({{< ref "/ngf/waf-integration/configuration.md#configure-automatic-policy-updates-polling" >}}). Once the settings agree, the conflict clears and the previously rejected policy is accepted.

The `WAFPolicy` that shows `Accepted: True` is the one NGINX Gateway Fabric applies; a policy marked `Conflicted` is not applied until the conflict is resolved. Confirm that the accepted policy is deployed by checking its `Programmed` condition with `kubectl describe wafpolicy <NAME>`.

---

### Security events aren't reaching NGINX Instance Manager

F5 WAF for NGINX generates security events, but they don't appear in the NGINX Instance Manager Security Monitoring dashboard, even though the `WAFPolicy` resource shows `Programmed`.

**How to identify the problem:**

Check whether the event reached NGINX Agent inside the pod:

```shell
kubectl exec <GATEWAY_POD> -n <NAMESPACE> -c nginx -- \
  tail -100 /var/log/nginx-agent/opentelemetry-collector-agent.log
```

If the event isn't in this log, F5 WAF for NGINX isn't reaching NGINX Agent. If the event is in the log but not in NGINX Instance Manager, the export from NGINX Agent is failing.

**Resolution:**

- **Event missing from the NGINX Agent log:** Confirm the `WAFPolicy` `securityLogs.destination.syslog.server` field is set to exactly `localhost:1514`. Any other value prevents the event from reaching NGINX Agent, which listens on `127.0.0.1:1514` inside the `nginx` container.
- **Event in the log but export fails:** Check the log for `Unauthenticated` errors. A JWT authentication failure between NGINX Agent and NGINX Instance Manager causes this error. This is the same NGINX Plus subscription JWT used to create the NGINX Plus Secret in [Connect NGINX Gateway Fabric to NGINX Instance Manager]({{< ref "/nim/connect-kubernetes/connect-ngf.md" >}}). If the JWT has expired or was revoked, download a new one from [MyF5](https://my.f5.com/manage/s/) and repeat the steps to recreate the Secret. NGINX Gateway Fabric doesn't pick up a rotated Secret automatically. Restart the Gateway pod after recreating it.
- **Export succeeds but NGINX Instance Manager shows nothing:** Confirm NGINX Instance Manager's embedded OpenTelemetry collector is running and reachable on port `4317`. See [Troubleshooting]({{< ref "/nim/security-monitoring/troubleshooting.md" >}}) for the NGINX Instance Manager–side checks.

---

## See also

- [F5 WAF for NGINX overview]({{< ref "/ngf/waf-integration/overview.md" >}})
- [Configure WAF settings]({{< ref "/ngf/waf-integration/configuration.md" >}})
- [WAFPolicy and NginxProxy API reference]({{< ref "/ngf/reference/api.md" >}})
