---
title: Gateway API Inference Extension
weight: 800
toc: true
f5-content-type: how-to
f5-product: NGINX Gateway Fabric
f5-docs: DOCS-0000
---

Learn how to use NGINX Gateway Fabric with the Gateway API Inference Extension to optimize traffic routing to self-hosting Generative AI Models on Kubernetes. 

## Overview

The [Gateway API Inference Extension](https://gateway-api-inference-extension.sigs.k8s.io/) is an official Kubernetes project that aims to provide optimized load-balancing for self-hosted Generative AI Models on Kubernetes. 
The project's goal is to improve and standardize routing to inference workloads across the ecosystem. 

Coupled with the provided llm-d Router, NGINX Gateway Fabric becomes an [Inference Gateway](https://gateway-api-inference-extension.sigs.k8s.io/#concepts-and-definitions). An Inference Gateway adds AI-specific traffic management features, such as model-aware routing, serving priority for models, and model rollouts. 

## Set up

Install the Gateway API Inference Extension CRDs:

```shell
kubectl kustomize "https://github.com/nginx/nginx-gateway-fabric/config/crd/inference-extension/?ref=v{{< version-ngf >}}" | kubectl apply -f -
```

To enable the Gateway API Inference Extension, [install]({{< ref "/ngf/install/" >}}) NGINX Gateway Fabric with these modifications:

- Using Helm: set the `nginxGateway.gwAPIInferenceExtension.enable=true` Helm value.
- Using Kubernetes manifests: set the `--gateway-api-inference-extension` flag in the nginx-gateway container argument, update the ClusterRole RBAC to add the `inferencepools`:

```yaml
- apiGroups:
    - inference.networking.k8s.io
    resources:
    - inferencepools
    verbs:
    - get
    - list
    - watch
- apiGroups:
    - inference.networking.k8s.io
    resources:
    - inferencepools/status
    verbs:
    - update
```

See this [example manifest](https://raw.githubusercontent.com/nginx/nginx-gateway-fabric/main/deploy/inference/deploy.yaml) for clarification.

{{< call-out class="warning" >}} By default, NGINX Gateway Fabric verifies the Endpoint Picker's TLS certificate (--endpoint-picker-tls-skip-verify=false). For testing or development environments without certificates, you can disable verification:

- Using Helm: set `nginxGateway.gwAPIInferenceExtension.endpointPicker.skipVerify=true` (or disable TLS entirely using `nginxGateway.gwAPIInferenceExtension.endpointPicker.disableTLS=true`).
- Using manifests: add `--endpoint-picker-tls-skip-verify=true` (or disable TLS using `--endpoint-picker-disable-tls`). {{< /call-out >}}

### Set up cert-manager

Make sure you have a Certificate Authority (CA) and a tool to issue certificates. This guide uses [cert-manager]({{< ref "/ngf/install/secure-certificates.md" >}}). If `cert-manager` is not yet installed in your cluster, follow the [Securing backend traffic using mutual TLS]({{< ref "/ngf/traffic-security/secure-backend.md" >}}) guide to deploy cert-manager and configure a `local-ca-issuer`.

### Create the Endpoint Picker TLS certificate

If using cert-manager, create a `Certificate` with Subject Alternative Names (SANs) matching the Endpoint Picker Service:

```yaml
kubectl apply -f - <<EOF
apiVersion: cert-manager.io/v1
kind: Certificate
metadata:
  name: epp-cert
  namespace: default
spec:
  secretName: epp-ca
  issuerRef:
    name: local-ca-issuer
    kind: ClusterIssuer
  dnsNames:
  - vllm-qwen3-32b-epp.default.svc
  - vllm-qwen3-32b-epp.default.svc.cluster.local
  - vllm-qwen3-32b-epp
EOF
```

Confirm that cert-manager issued the certificate:

```shell
kubectl get certificate epp-cert
```

## Deploy a sample model server

The [vLLM simulator](https://github.com/llm-d/llm-d-inference-sim) model server does not use GPUs and is ideal for test/development environments. To deploy the vLLM simulator, run the following command:

```shell
kubectl apply -f https://raw.githubusercontent.com/kubernetes-sigs/gateway-api-inference-extension/refs/tags/v{{< version-inference-extension >}}/config/manifests/vllm/sim-deployment.yaml
```

## Deploy the InferencePool and llm-d router

The InferencePool is a Gateway API Inference Extension resource that represents a set of Inference-focused Pods. With InferencePool, you can configure a routing extension as well as inference-specific routing optimizations. For more information on this resource, refer to the Gateway API Inference Extension [InferencePool documentation](https://gateway-api-inference-extension.sigs.k8s.io/api-types/inferencepool/).

Install an InferencePool named `vllm-qwen3-32b` that selects from endpoints with label `app: vllm-qwen3-32b` and listening on port 8000. The Helm install command automatically installs the llm-d router and InferencePool.

NGINX queries the llm-d Router to find the pod endpoint that gets the traffic. The llm-d Router picks from the ready pods that the InferencePool `selector` field matches. For more information, see the README for the llm-d router's [Endpoint Picker](https://github.com/llm-d/llm-d-router/blob/main/pkg/epp/README.md).

{{< call-out class="warning" >}} The llm-d router is a third-party application written and provided by the llm-d project. By default, NGINX Gateway Fabric connects to the llm-d router's Endpoint Picker over TLS and verifies its certificate. To verify the certificate, follow the **Configure TLS verification for the Endpoint Picker** steps. NGINX Gateway Fabric is not responsible for any threats or risks associated with using this third-party llm-d router application. {{< /call-out >}}

{{< call-out class="tip" >}}
For all chart values, see the [llm-d Router Helm charts](https://github.com/llm-d/llm-d-router/tree/main/config/charts).
{{< /call-out >}}

```shell
helm install vllm-qwen3-32b  \
--set router.modelServers.matchLabels.app=vllm-qwen3-32b \
--version v{{< ngf-version-llmd-router >}} \
--set-json 'router.epp.volumes=[{"name":"tls","secret":{"secretName":"epp-ca"}}]' \
--set-json 'router.epp.volumeMounts=[{"name":"tls","mountPath":"/etc/tls","readOnly":true}]' \
oci://ghcr.io/llm-d/charts/llm-d-router-gateway
```

{{< call-out class="tip" title="Test environments only" >}} For test environments, lower the CPU and memory requests and limits to reduce resource use:

```shell
helm install vllm-qwen3-32b  \
--set router.modelServers.matchLabels.app=vllm-qwen3-32b \
--version v{{< ngf-version-llmd-router >}} \
--set router.epp.resources.requests.cpu=100m \
--set router.epp.resources.requests.memory=512Mi \
--set router.epp.resources.limits.memory=2Gi \
--set-json 'router.epp.volumes=[{"name":"tls","secret":{"secretName":"epp-ca"}}]' \
--set-json 'router.epp.volumeMounts=[{"name":"tls","mountPath":"/etc/tls","readOnly":true}]' \
oci://ghcr.io/llm-d/charts/llm-d-router-gateway
```

{{< /call-out >}}

Confirm that the llm-d router was deployed and is running:

```shell
kubectl describe deployment vllm-qwen3-32b-epp
```

## Configure TLS verification for the Endpoint Picker

By default, NGINX Gateway Fabric connects to the Endpoint Picker over TLS and verifies its certificate. To verify the certificate, attach a [BackendTLSPolicy](https://gateway-api.sigs.k8s.io/reference/api-types/policy/backendtlspolicy/) to the Endpoint Picker Service. NGINX Gateway Fabric then validates the Endpoint Picker's certificate against the CA you provide during the TLS handshake.

The Endpoint Picker must serve TLS with a certificate that the referenced CA signed, and that certificate must include the hostname you set in the policy. Because NGINX Gateway Fabric doesn't manage the Endpoint Picker, configuring server-side TLS is the responsibility of the Endpoint Picker deployment.

Create a BackendTLSPolicy that targets the Endpoint Picker Service named in your InferencePool's `endpointPickerRef`. The following example targets the `vllm-qwen3-32b-epp` Service and validates its certificate against the CA in the `epp-ca` Secret:

```yaml
kubectl apply -f - <<EOF
apiVersion: gateway.networking.k8s.io/v1
kind: BackendTLSPolicy
metadata:
  name: epp-tls
spec:
  targetRefs:
  - group: ''
    kind: Service
    name: vllm-qwen3-32b-epp
  validation:
    caCertificateRefs:
    - name: epp-ca
      group: ''
      kind: Secret
    hostname: vllm-qwen3-32b-epp.default.svc
EOF
```

## Deploy an Inference Gateway

```yaml
kubectl apply -f - <<EOF
apiVersion: gateway.networking.k8s.io/v1
kind: Gateway
metadata:
  name: inference-gateway
spec:
  gatewayClassName: nginx
  listeners:
  - name: http
    port: 80
    protocol: HTTP
EOF
```

Confirm that the Gateway was assigned an IP address and reports a `Programmed=True` status:

```shell
kubectl describe gateways.gateway.networking.k8s.io inference-gateway
```

```text
Status:
  Addresses:
    Type:   IPAddress
    Value:  10.96.36.219
  Conditions:
    Last Transition Time:  2026-01-09T05:40:37Z
    Message:               The Gateway is accepted
    Observed Generation:   1
    Reason:                Accepted
    Status:                True
    Type:                  Accepted
    Last Transition Time:  2026-01-09T05:40:37Z
    Message:               The Gateway is programmed
    Observed Generation:   1
    Reason:                Programmed
    Status:                True
    Type:                  Programmed
```

Save the public IP address and port(s) of the Gateway into shell variables:

```text
GW_IP=XXX.YYY.ZZZ.III
GW_PORT=<port number>
```

## Deploy an HTTPRoute

```yaml
kubectl apply -f - <<EOF
apiVersion: gateway.networking.k8s.io/v1
kind: HTTPRoute
metadata:
  name: llm-route
spec:
  parentRefs:
  - group: gateway.networking.k8s.io
    kind: Gateway
    name: inference-gateway
  rules:
  - backendRefs:
    - group: inference.networking.k8s.io
      kind: InferencePool
      name: vllm-qwen3-32b
    matches:
    - path:
        type: PathPrefix
        value: /
EOF
```

Confirm that the HTTPRoute status conditions include `Accepted=True` and `ResolvedRefs=True`:

```shell
kubectl describe httproute llm-route
```

## Try it out

Send traffic to the Gateway: 

```shell
curl -i $GW_IP:$GW_PORT/v1/completions -H 'Content-Type: application/json' -d '{
"model": "food-review-1",
"prompt": "Write as if you were a critic: San Francisco",
"max_tokens": 100,
"temperature": 0
}'
```

## Cleanup

Uninstall the InferencePool and model server resources:

```shell
helm uninstall vllm-qwen3-32b
kubectl delete -f https://raw.githubusercontent.com/kubernetes-sigs/gateway-api-inference-extension/refs/tags/v{{< version-inference-extension >}}/config/manifests/vllm/sim-deployment.yaml
```

Uninstall the Gateway API Inference Extension CRDs:

```shell
kubectl delete -k https://github.com/kubernetes-sigs/gateway-api-inference-extension/config/crd --ignore-not-found
```

Uninstall Inference Gateway and HTTPRoute:

```shell
kubectl delete gateway inference-gateway
kubectl delete httproute llm-route
```

Uninstall NGINX Gateway Fabric:

```shell
helm uninstall ngf -n nginx-gateway
```

If needed, replace ngf with your chosen release name.

Remove namespace and NGINX Gateway Fabric CRDs:

```shell
kubectl delete ns nginx-gateway
kubectl delete -f https://raw.githubusercontent.com/nginx/nginx-gateway-fabric/v{{< version-ngf >}}/deploy/crds.yaml
```

Remove the BackendTLSPolicy and certificate:

```shell 
kubectl delete backendtlspolicy epp-tls
kubectl delete certificate epp-cert
kubectl delete secret epp-ca --ignore-not-found
```

Remove the Gateway API CRDs:

{{< include "/ngf/installation/uninstall-gateway-api-resources.md" >}}

## See also

- [Gateway API Inference Extension Introduction](https://gateway-api-inference-extension.sigs.k8s.io/): for introductory details to the project.
- [Gateway API Inference Extension API Overview](https://gateway-api-inference-extension.sigs.k8s.io/concepts/api-overview/): for an API overview.
- [Gateway API Inference Extension User Guides](https://gateway-api-inference-extension.sigs.k8s.io/guides/implementers/): for additional use cases and guides.
- [llm-d](https://github.com/llm-d/llm-d): for information on the llm-d project.
- [Securing backend traffic using mutual TLS]({{< ref "/ngf/traffic-security/secure-backend.md" >}}): for more on BackendTLSPolicy and backend certificate validation.
