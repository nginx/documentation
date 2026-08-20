---
f5-product: F5 WAF for NGINX
f5-files:
- content/ngf/waf-integration/get-started-plm.md
---

<!-- Maintainer note: This include is product-agnostic. It covers all three APPolicy definition methods (inline, Git reference, precompiled bundle) in a tabbed UI. Content ends before any product-specific policy attachment resource (WAFPolicy for NGF, Policy for NIC). The ReferenceGrant required for cross-namespace WAFPolicy refs in NGF is not included here — add it in the parent tutorial after this include. The security namespace is created in plm-configure-logging.md, which runs before this include in the tutorial. -->

This section is typically owned by the security team. They define the policy in the `security` namespace, separate from the Gateway namespace, so security resources are managed independently from routing configuration. If you're not on the security team, share this section with them — you'll need the `APPolicy` name and namespace before continuing.

The `APPolicy` resource defines the security policy. The PLM controller watches it, compiles it, and writes `status.bundle` with `state: ready` when the bundle is available.

{{<tabs name="plm-policy-definition-methods">}}

{{%tab name="Inline"%}}

Create an `APPolicy` resource with an inline policy that blocks all attack signatures:

```yaml
kubectl apply -f - <<EOF
apiVersion: appprotect.f5.com/v1
kind: APPolicy
metadata:
  name: attack-signatures
  namespace: security
spec:
  policy:
    name: attack-signatures-blocking
    template:
      name: POLICY_TEMPLATE_NGINX_BASE
    applicationLanguage: utf-8
    enforcementMode: blocking
    signature-sets:
    - name: All Signatures
      block: true
      alarm: true
    cookies:
    - name: "*"
      attackSignaturesCheck: true
      enforcementType: enforce
      maskValueInLogs: false
EOF
```

Wait for the bundle to become ready:

```shell
kubectl wait --for=jsonpath='{.status.bundle.state}'=ready appolicy/attack-signatures -n security --timeout=60s
```

{{% /tab %}}

{{%tab name="Git reference"%}}

Store your policy JSON in a Git repository and reference it from `APPolicy`.

#### Public repository

Create an `APPolicy` resource that references the policy file by path. Replace `<POLICY_NAME>`, `<NAMESPACE>`, `<PATH/TO/POLICY.JSON>`, `<ORG>`, `<REPO>`, and `<TAG_OR_COMMIT>` with your values:

```shell
kubectl apply -f - <<'EOF'
apiVersion: appprotect.f5.com/v1
kind: APPolicy
metadata:
  name: <POLICY_NAME>
  namespace: <NAMESPACE>
spec:
  policy:
    $ref: <PATH/TO/POLICY.JSON>
    externalReferenceDetails:
      repositoryDetails:
        repository: https://github.com/<ORG>/<REPO>.git
        ref: "<TAG_OR_COMMIT>"
EOF
```

{{< call-out class="note" title="Note" >}} Pin `ref` to a tag or commit SHA rather than a branch name in production environments. {{< /call-out >}}

Check that the bundle compiled successfully:

```shell
kubectl get appolicy <POLICY_NAME> \
  --namespace <NAMESPACE> \
  --output jsonpath='State:    {.status.bundle.state}{"\n"}Bundle:   {.status.bundle.location}{"\n"}Compiler: {.status.bundle.compilerVersion}{"\n"}'
```

The output shows `State: ready` when compilation succeeds.

#### Private repository

For private repositories, create a Kubernetes Secret with your personal access token (PAT):

```shell
kubectl create secret generic git-token-secret \
  --namespace <NAMESPACE> \
  --from-literal=token=<GIT_PERSONAL_ACCESS_TOKEN>
```

Then reference the Secret in the `APPolicy` resource:

```shell
kubectl apply -f - <<'EOF'
apiVersion: appprotect.f5.com/v1
kind: APPolicy
metadata:
  name: <POLICY_NAME>
  namespace: <NAMESPACE>
spec:
  policy:
    $ref: <PATH/TO/POLICY.JSON>
    externalReferenceDetails:
      repositoryDetails:
        repository: https://github.com/<ORG>/<REPO>.git
        ref: "<TAG_OR_COMMIT>"
      authentication:
        token: git-token-secret
EOF
```

#### Update a Git-referenced policy

The Policy Controller doesn't poll the Git repository for changes. To pick up changes to the referenced policy file, re-apply the `APPolicy` resource (or update its revision annotation) after you push changes to the repository.

{{% /tab %}}

{{%tab name="Precompiled bundle"%}}

The precompiled-bundle method lets you reference a `.tgz` policy bundle stored in an artifact registry (for example, Artifactory or Nexus). The Policy Controller imports the bundle and stores it in the SeaweedFS object store without recompiling it.

Use this method when:

- Your security team compiles and publishes bundles through an external pipeline.
- You want to decouple policy compilation from cluster operations.

Create an `APPolicy` resource that references your bundle. Replace `<POLICY_NAME>`, `<ARTIFACT_REGISTRY_HOST>`, and `<PATH/TO/POLICY_BUNDLE>` with your values:

```shell
kubectl apply -f - <<'EOF'
apiVersion: appprotect.f5.com/v1
kind: APPolicy
metadata:
  name: <POLICY_NAME>
  namespace: plm-system
spec:
  policy:
    $ref: "https://<ARTIFACT_REGISTRY_HOST>/<PATH/TO/POLICY_BUNDLE>.tgz"
EOF
```

{{< call-out class="note" title="Note" >}}
The Policy Controller must reach the artifact registry over HTTPS. If the registry uses a private certificate authority (CA), mount the CA certificate into the Policy Controller pod and set the `SSL_CERT_FILE` environment variable to its path. `SSL_CERT_FILE` replaces the system trust store entirely — it doesn't append to it. If SeaweedFS TLS is also enabled, combine both CAs into a single file and reference that file.
{{< /call-out >}}

If the `APPolicy` status shows `x509: certificate signed by unknown authority`, the Policy Controller doesn't trust the artifact registry CA. Check the status for the full error:

```shell
kubectl describe appolicy <POLICY_NAME> --namespace plm-system
```

#### Confirm the policy is ready

The Policy Controller processes the bundle and updates the `APPolicy` status. Check the `bundle.state` field:

```shell
kubectl get appolicy <POLICY_NAME> \
  --namespace plm-system \
  --output jsonpath='State:      {.status.bundle.state}{"\n"}Bundle:     {.status.bundle.location}{"\n"}isCompiled: {.status.processing.isCompiled}{"\n"}'
```

When the bundle is ready, the output looks like this:

```text
State:      ready
Bundle:     s3://plm-system/bundles/<POLICY_NAME>_imported_<HASH>.tgz
isCompiled: false
```

`isCompiled: false` confirms the bundle was imported as-is and not recompiled.

`bundle.state` can be one of:

| State | Meaning |
|-------|---------|
| `pending` | The Policy Controller hasn't yet processed the resource. |
| `processing` | The Policy Controller is importing or storing the bundle. |
| `ready` | The bundle is stored and ready to use. `bundle.location` is populated. |
| `invalid` | The bundle couldn't be imported. Check the status for error detail. |

#### Update a precompiled bundle

The Policy Controller doesn't poll the artifact registry for changes. To pick up a new version of a bundle, update the `$ref` URL in your `APPolicy` resource (or bump its revision annotation) and reapply it. Replace `<POLICY_NAME>`, `<ARTIFACT_REGISTRY_HOST>`, and `<PATH/TO/UPDATED_POLICY_BUNDLE>` with your values:

```shell
kubectl apply -f - <<'EOF'
apiVersion: appprotect.f5.com/v1
kind: APPolicy
metadata:
  name: <POLICY_NAME>
  namespace: plm-system
spec:
  policy:
    $ref: "https://<ARTIFACT_REGISTRY_HOST>/<PATH/TO/UPDATED_POLICY_BUNDLE>.tgz"
EOF
```

{{% /tab %}}

{{</tabs>}}
