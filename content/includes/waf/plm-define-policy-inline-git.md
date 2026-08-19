---
f5-product: F5 WAF for NGINX
f5-files:
- content/ngf/waf-integration/get-started-plm.md
---

<!-- Maintainer note: This include covers the Inline and Git reference APPolicy definition methods. It is product-agnostic and ends before any product-specific policy attachment resource (WAFPolicy for NGF, Policy for NIC). The ReferenceGrant required for cross-namespace WAFPolicy refs in NGF is not included here — add it in the parent tutorial after this include. The precompiled-bundle method is in a separate include (plm-define-policy-bundle-method.md). -->

This section is typically owned by the security team. They define the policy in the `security` namespace, separate from the Gateway namespace, so security resources are managed independently from routing configuration. If you're not on the security team, share this section with them — you'll need the `APPolicy` name and namespace before continuing.

The `APPolicy` resource defines the security policy. The PLM controller watches it, compiles it, and writes `status.bundle` with `state: ready` when the bundle is available.

### Inline policy

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

### Git-referenced policy

Store your policy JSON in a Git repository and reference it from `APPolicy`.

#### Public repository

Create an `APPolicy` resource that references the policy file by path. Replace `<POLICY_NAME>`, `<NAMESPACE>`, `<PATH/TO/POLICY.JSON>`, `<ORG>`, `<REPO>`, and `<TAG_OR_COMMIT>` with your values:

```shell
kubectl apply -f - <<EOF
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
kubectl apply -f - <<EOF
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
