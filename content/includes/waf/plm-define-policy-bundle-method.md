---
f5-product: F5 WAF for NGINX
f5-files:
- content/ngf/waf-integration/get-started-plm.md
- content/nic/waf-integration/get-started-plm.md
---

The precompiled-bundle method lets you reference a `.tgz` policy bundle stored in an artifact registry (for example, Artifactory or Nexus). The Policy Controller imports the bundle and stores it in the SeaweedFS object store without recompiling it.

Use this method when:

- Your security team compiles and publishes bundles through an external pipeline.
- You want to decouple policy compilation from cluster operations.

Create an `APPolicy` resource that references your bundle:

```yaml
apiVersion: appprotect.f5.com/v1
kind: APPolicy
metadata:
  name: <POLICY_NAME>
  namespace: <NAMESPACE>
spec:
  policy:
    $ref: "https://<ARTIFACT_REGISTRY_HOST>/<PATH/TO/POLICY_BUNDLE>.tgz"
```

Replace `<POLICY_NAME>`, `<NAMESPACE>`, `<ARTIFACT_REGISTRY_HOST>`, and `<PATH/TO/POLICY_BUNDLE>` with your values.

Apply the resource:

```shell
kubectl apply -f <POLICY_MANIFEST>.yaml
```

{{< call-out class="note" title="Note" >}}
The Policy Controller must be able to reach the artifact registry host over HTTPS. If the registry uses a private certificate authority, configure the Policy Controller to trust that CA. <!-- TODO: SME to confirm and document the Helm value or config mechanism for trusting a private CA on the bundle server. -->
{{< /call-out >}}

**Confirm the policy is ready.** The Policy Controller processes the bundle and updates the `APPolicy` status. Check the `bundle.state` field:

```shell
kubectl get appolicy <POLICY_NAME> \
  --namespace <NAMESPACE> \
  --output jsonpath='State:      {.status.bundle.state}{"\n"}Bundle:     {.status.bundle.location}{"\n"}isCompiled: {.status.processing.isCompiled}{"\n"}'
```

When the bundle is ready, the output looks like this:

```text
State:      ready
Bundle:     s3://<namespace>/bundles/<policy-name>_imported_<hash>.tgz
isCompiled: false
```

`isCompiled: false` confirms the bundle was imported as-is and not recompiled.

`bundle.state` can be one of:

| State | Meaning |
|-------|---------|
| `pending` | The Policy Controller has not yet processed the resource. |
| `processing` | The Policy Controller is importing or storing the bundle. |
| `ready` | The bundle is stored and ready to use. `bundle.location` is populated. |
| `invalid` | The bundle could not be imported. Check the status for error detail. |

**Update a precompiled bundle.** The Policy Controller does not poll the artifact registry for changes. To pick up a new version of a bundle, update the `APPolicy` resource to reference the new bundle URL (or bump its revision annotation) and re-apply it:

```shell
kubectl apply -f <UPDATED_POLICY_MANIFEST>.yaml
```
