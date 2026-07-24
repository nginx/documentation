---
title: Troubleshoot WAFPolicy status
weight: 500
toc: true
f5-content-type: reference
f5-product: FABRIC
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
| `False` | `Conflicted`       | Another WAFPolicy already targets this resource at the same level           |
| `False` | `NginxProxyNotSet` | WAF is not enabled in the referenced NginxProxy                             |

### ResolvedRefs

| Status  | Reason            | Meaning                                                                                     |
|---------|-------------------|---------------------------------------------------------------------------------------------|
| `True`  | `ResolvedRefs`    | All referenced Secrets, `APPolicy`, and `APLogConf` resources resolved successfully         |
| `False` | `InvalidRef`      | A referenced Secret was not found or is missing keys; or (PLM) a referenced `APPolicy`/`APLogConf` does not exist or its `status.bundle.state` is not `ready` |
| `False` | `RefNotPermitted` | (PLM) A cross-namespace `APPolicy` or `APLogConf` reference is not allowed by a `ReferenceGrant` |

### Programmed

| Status  | Reason               | Meaning                                                                                          |
|---------|----------------------|--------------------------------------------------------------------------------------------------|
| `True`  | `Programmed`         | Bundle fetched and deployed to the data plane                                                    |
| `True`  | `BundleUpdated`      | A poll cycle detected a changed bundle and deployed it                                           |
| `True`  | `StaleBundleWarning` | A poll cycle failed; previously deployed bundle remains active                                   |
| `False` | `FetchError`         | Bundle could not be fetched (network error, HTTP error, S3 error for PLM, auth failure, timeout) |
| `False` | `IntegrityError`     | Bundle checksum verification failed                                                              |
| `False` | `Pending`            | Bundle has never been fetched; configuration withheld or WAF omitted (fail-open)                 |

---

## Common issues

### `FetchError` with HTTP 403

The credentials Secret is either missing, contains the wrong keys, or the credentials are invalid. Verify the Secret exists in the same namespace as the `WAFPolicy` and that the keys match the authentication method (`username`/`password` for Basic Auth, `token` for Bearer/APIToken).

### `FetchError` with HTTP 404 on NGINX Instance Manager or NGINX One Console

The referenced policy was not found or has not been compiled yet. For NGINX Instance Manager, verify that compilation succeeded in the NGINX Instance Manager console before creating the `WAFPolicy`. For NGINX One Console, NGINX Gateway Fabric triggers compilation if no bundle exists, and a 404 after initial setup may indicate the policy was deleted in NGINX One Console.

### `InvalidRef` on a PLM policy: `APPolicy` not ready

For `type: PLM`, NGINX Gateway Fabric only fetches a bundle once the referenced `APPolicy` (or `APLogConf`) reports `status.bundle.state: ready`. While PLM is still compiling, the `ResolvedRefs` condition is `False` with reason `InvalidRef`:

```text
- Type:    ResolvedRefs
  Status:  False
  Reason:  InvalidRef
  Message: APLogConf namespace/name bundle is not ready (state: processing)
```

Verify the `APPolicy` exists and that PLM has finished compiling it: `kubectl get appolicy -n <namespace>`. If the state is `invalid`, check the PLM compilation errors in the resource's `status`.

### `RefNotPermitted` on a PLM policy: missing `ReferenceGrant`

When a `WAFPolicy` references an `APPolicy` or `APLogConf` in a different namespace, a `ReferenceGrant` must exist in the target namespace:

```text
- Type:    ResolvedRefs
  Status:  False
  Reason:  RefNotPermitted
  Message: cross-namespace reference to APLogConf namespace/name not permitted by ReferenceGrant
```

Create a `ReferenceGrant` in the target namespace that allows `WAFPolicy` resources from the source namespace to reference the `APPolicy`/`APLogConf` Kinds. See [Cross-namespace references]({{< ref "/ngf/waf-integration/policy-sources.md#cross-namespace-references" >}}).

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

If two `WAFPolicy` resources in the same Gateway reference different compiled bundles that were compiled under the **same policy name**, the WAF engine rejects the configuration with an error like:

```text
"error_message": "Duplicate policy name found: <PolicyName>"
```

This occurs because the WAF engine uses the logical policy name embedded inside the compiled bundle — not the Kubernetes resource name or bundle filename — to identify policies. When the same logical name appears more than once in a single NGINX configuration, the configuration test fails and the update is rolled back.

**How to identify the problem:**

Check the NGINX Gateway Fabric controller logs for a configuration error containing `Duplicate policy name found`:

```shell
kubectl logs -n nginx-gateway deploy/nginx-gateway -c nginx-gateway | grep "Duplicate policy name"
```

**Resolution:**

Each `WAFPolicy` attached to a Gateway must reference a compiled bundle with a unique logical policy name. This is the `name` field set inside the policy definition JSON at compile time, not the `WAFPolicy` resource name or the bundle filename.

To resolve the conflict, choose one of the following approaches:

- **Recompile with a distinct name**: Update the policy definition to use a unique `name` field for each policy, then recompile and republish the bundle.
- **Pin a single version per Gateway**: If the intent is to apply the same policy everywhere, use a single gateway-level `WAFPolicy` instead of multiple route-level policies referencing different versions of the same named policy.
- **Check for overlapping WAFPolicies**: Run `kubectl get wafpolicies -A` and confirm that no two policies targeting the same Gateway reference bundles compiled from definitions with the same logical policy name.

---

## See also

- [F5 WAF for NGINX overview]({{< ref "/ngf/waf-integration/overview.md" >}})
- [Configure WAF settings]({{< ref "/ngf/waf-integration/configuration.md" >}})
- [WAFPolicy and NginxProxy API reference]({{< ref "/ngf/reference/api.md" >}})
