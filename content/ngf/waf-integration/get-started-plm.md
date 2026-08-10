---
title: Get started with F5 WAF for NGINX (PLM)
weight: 199
toc: true
f5-content-type: tutorial
f5-docs: DOCS-000
f5-product: F5 NGINX Gateway Fabric
f5-description: Tutorial for setting up F5 WAF for NGINX with a PLM-based policy workflow in F5 NGINX Gateway Fabric.
f5-keywords: "F5 NGINX Gateway Fabric, F5 WAF for NGINX, policy lifecycle manager, tutorial, step by step, beginner"
f5-summary: >
  Set up and validate a policy lifecycle workflow for F5 WAF for NGINX in F5 NGINX Gateway Fabric.
  Learn how to deploy a sample app, attach a WAFPolicy, and verify policy enforcement.
  This tutorial is for platform engineers and operators with basic Kubernetes and Gateway API knowledge.
f5-audience: operator
---

<!-- TODO: Write introduction. Cover: what PLM is (Policy Lifecycle Manager), the operator pattern, how it fits into the NGF + F5 WAF for NGINX workflow, and what the reader will have at the end of this tutorial. See TECHDOCS-5338. -->

## Before you begin

<!-- TODO: Write prerequisites section (Story 2 / TECHDOCS-5342). Must cover: installed NGF, F5 WAF for NGINX credentials (JWT, nginx-repo.crt, nginx-repo.key, registry token), kubectl + Helm access. -->

## Deploy PLM infrastructure

{{< include "waf/plm-deploy-infrastructure.md" >}}

## Configure NGF to connect to PLM storage

<!-- TODO: Write this section (Story 4). Covers connecting NGINX Gateway Fabric to the SeaweedFS S3 endpoint so it can pull compiled bundles. -->

## Enable WAF in the NginxProxy resource

<!-- TODO: Write this section (Story 5). Covers turning on WAF in the NginxProxy resource. Confirm with SME whether this folds into Story 2 (Deploy PLM infrastructure). -->

## Configure security logging (optional)

<!-- TODO (TECHDOCS-5346 / Story 6): Write this section. Covers APLogConf authoring and referencing it from securityLogs. This section is referenced from "Define the WAF policy" above and must be present for that cross-link to resolve. -->

## Define the WAF policy

The `APPolicy` custom resource defines what F5 WAF for NGINX enforces. The `APLogConf` custom resource defines what it logs — see [Configure security logging](#configure-security-logging-optional) for details. The Policy Controller watches both resources and compiles them into bundles stored in the SeaweedFS object store.

This section covers three ways to define a WAF policy. Choose the method that fits your workflow:

| Method | When to use |
|--------|-------------|
| [Inline](#inline-method) | You want to define the policy directly in the Kubernetes resource. Good for getting started or for simple policies. |
| [Git reference](#git-reference-method) | Your policy JSON lives in a Git repository and you want the Policy Controller to fetch and compile it. |
| [Precompiled bundle](#precompiled-bundle-method) | Your security team publishes compiled bundles to an artifact registry. The Policy Controller imports the bundle without recompiling. |

### Inline method

The inline method embeds the full policy definition in the `APPolicy` resource. The Policy Controller converts and compiles it.

Create an `APPolicy` resource with the policy embedded under `spec.policy`:

```yaml
apiVersion: appprotect.f5.com/v1
kind: APPolicy
metadata:
  name: <POLICY_NAME>
  namespace: <NAMESPACE>
spec:
  policy:
    name: <POLICY_NAME>
    template:
      name: POLICY_TEMPLATE_NGINX_BASE
    applicationLanguage: utf-8
    enforcementMode: blocking
```

Replace `<POLICY_NAME>` and `<NAMESPACE>` with your values. Extend `spec.policy` with the policy fields you want to enforce.

Apply the resource:

```shell
kubectl apply -f <POLICY_MANIFEST>.yaml
```

#### Confirm the policy is ready

Check the `bundle.state` field to confirm the Policy Controller compiled the policy:

```shell
kubectl get appolicy <POLICY_NAME> \
  --namespace <NAMESPACE> \
  --output jsonpath='State:    {.status.bundle.state}{"\n"}Bundle:   {.status.bundle.location}{"\n"}Compiler: {.status.bundle.compilerVersion}{"\n"}'
```

When compilation succeeds, the output looks like this:

```text
State:    ready
Bundle:   s3://<namespace>/bundles/<policy-name><timestamp>.tgz
Compiler: <compiler-version>
```

`bundle.state` can be one of:

| State | Meaning |
|-------|---------|
| `pending` | The Policy Controller has not yet processed the resource. |
| `processing` | The Policy Controller is compiling the policy. |
| `ready` | Compilation succeeded. `bundle.location` is populated. |
| `invalid` | Compilation failed. Check the status for error detail. |

To update an inline policy, edit the `APPolicy` resource and re-apply it. The Policy Controller recompiles the policy when the resource spec changes.

### Git reference method

The Git reference method lets you store your policy JSON in a Git repository. The Policy Controller fetches the file and compiles it.

#### Public repository

Create an `APPolicy` resource that references the policy file by path:

```yaml
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
```

Replace `<POLICY_NAME>`, `<NAMESPACE>`, `<PATH/TO/POLICY.JSON>`, `<ORG>`, `<REPO>`, and `<TAG_OR_COMMIT>` with your values.

{{< call-out class="note" title="Note" >}}
Pin `ref` to a tag or commit SHA rather than a branch name in production environments.
{{< /call-out >}}

Apply the resource:

```shell
kubectl apply -f <POLICY_MANIFEST>.yaml
```

#### Private repository

For private repositories, create a Kubernetes secret with your personal access token (PAT):

```shell
kubectl create secret generic git-token-secret \
  --namespace <NAMESPACE> \
  --from-literal=token=<GIT_PERSONAL_ACCESS_TOKEN>
```

Then reference the secret in the `APPolicy` resource:

```yaml
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
```

#### Confirm the policy is ready

Check `bundle.state` as described in [Confirm the policy is ready](#confirm-the-policy-is-ready).

#### Update a Git-referenced policy

The Policy Controller does not poll the Git repository for changes. To pick up changes to the referenced policy file, re-apply the `APPolicy` resource (or update its revision annotation) after you push changes to the repository.

### Precompiled bundle method

{{< include "waf/plm-define-policy-bundle-method.md" >}}

## Deploy the Gateway and attach WAFPolicy

<!-- TODO: Write this section (Story 8). Covers creating the Gateway resource and attaching a WAFPolicy. Note: WAFPolicy apiVersion is gateway.nginx.org/v1alpha1. Note: bundleFailOpen: false (default) withholds the entire NGINX config push until the bundle is available. -->

## Configure HTTPRoutes

<!-- TODO: Write this section (Story 9). Covers creating HTTPRoute resources. HTTPRoutes inherit WAF protection automatically from a Gateway-level WAFPolicy. -->

## Validate policy compilation and application

<!-- TODO: Write this section (Story 10). Covers confirming bundle.state = ready and that the compiled policy is applied to the data plane. -->

## Test deployment and policy enforcement

<!-- TODO: Write this section (Story 11). Covers sending test traffic to verify WAF enforcement. -->