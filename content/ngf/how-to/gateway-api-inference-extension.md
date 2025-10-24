---
title: Gateway API Inference Extension
weight: 800
toc: true
nd-type: how-to
nd-product: NGF
nd-docs: DOCS-0000
---

Learn how to use NGINX Gateway Fabric with the Gateway API Inference Extension to optimize traffic routing to self-hosting Generative AI Models on Kubernetes. 

## Overview

The [Gateway API Inference Extension](https://gateway-api-inference-extension.sigs.k8s.io/) is an official Kubernetes project that aims to provide optimized load-balancing for self-hosted Generative AI Models on Kubernetes. 
The project's goal is to improve and standardize routing to inference workloads across the ecosystem. 

Coupled with the provided Endpoint Picker Service, NGINX Gateway Fabric becomes an [Inference Gateway](https://gateway-api-inference-extension.sigs.k8s.io/#concepts-and-definitions), with additional AI specific traffic management features such as model-aware routing, serving priority for models, model rollouts, and more. 

{{< call-out "warning" >}} The Gateway API Inference Extension is still in alpha status and should not be used in production yet.{{< /call-out >}}

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


## Deploy a sample model server

The [vLLM simulator](https://github.com/llm-d/llm-d-inference-sim/tree/main) model server does not use GPUs and is ideal for test/development environments. This sample is configured to simulate the [meta-llama/LLama-3.1-8B-Instruct](https://huggingface.co/meta-llama/Llama-3.1-8B-Instruct) model. To deploy the vLLM simulator, run the following command:

```shell
kubectl apply -f https://github.com/kubernetes-sigs/gateway-api-inference-extension/raw/main/config/manifests/vllm/sim-deployment.yaml
```

## Deploy the InferencePool and Endpoint Picker Extension

The InferencePool is a Gateway API Inference Extension resource that represents a set of Inference-focused Pods. With InferencePool, you can configure a routing extension as well as inference-specific routing optimizations. For more information on this resource, refer to the Gateway API Inference Extension [InferencePool documentation](https://gateway-api-inference-extension.sigs.k8s.io/api-types/inferencepool/).

Install an InferencePool named `vllm-llama3-8b-instruct` that selects from endpoints with label `app: vllm-llama3-8b-instruct` and listening on port 8000. The Helm install command automatically installs the Endpoint Picker Extension and InferencePool.

NGINX will query the Endpoint Picker Extension to determine the appropriate pod endpoint to route traffic to. These pods are selected from a pool of ready pods designated by the assigned InferencePool's Selector field. For more information on the [Endpoint Picker](https://github.com/kubernetes-sigs/gateway-api-inference-extension/blob/main/pkg/epp/README.md).

{{< call-out "warning" >}} The Endpoint Picker Extension is a third-party application written and provided by the Gateway API Inference Extension project. Communication between NGINX and the Endpoint Picker uses TLS with certificate verification disabled by default, as the Endpoint Picker does not currently support mounting CA certificates. The Gateway API Inference Extension is in alpha status and should not be used in production. NGINX Gateway Fabric is not responsible for any threats or risks associated with using this third-party Endpoint Picker Extension application. {{< /call-out >}}

```shell
export IGW_CHART_VERSION=v1.0.1
helm install vllm-llama3-8b-instruct \
--set inferencePool.modelServers.matchLabels.app=vllm-llama3-8b-instruct \
--version $IGW_CHART_VERSION \
oci://registry.k8s.io/gateway-api-inference-extension/charts/inferencepool
```

Confirm that the Endpoint Picker was deployed and is running:

```shell
kubectl describe deployment vllm-llama3-8b-instruct-epp
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
kubectl describe gateway inference-gateway
```

Save the public IP address and port of the NGINX Service into shell variables:

```text
GW_IP=XXX.YYY.ZZZ.III
GW_PORT=<port number>
```

## Deploy a HTTPRoute

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
      name: vllm-llama3-8b-instruct
      port: 3000
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

Uninstall the InferencePool, InferenceObjective, and model server resources:


```shell
helm uninstall vllm-llama3-8b-instruct
kubectl delete -f https://github.com/kubernetes-sigs/gateway-api-inference-extension/raw/main/config/manifests/inferenceobjective.yaml --ignore-not-found
kubectl delete -f https://github.com/kubernetes-sigs/gateway-api-inference-extension/raw/main/config/manifests/vllm/cpu-deployment.yaml --ignore-not-found
kubectl delete -f https://github.com/kubernetes-sigs/gateway-api-inference-extension/raw/main/config/manifests/vllm/gpu-deployment.yaml --ignore-not-found
kubectl delete -f https://github.com/kubernetes-sigs/gateway-api-inference-extension/raw/main/config/manifests/vllm/sim-deployment.yaml --ignore-not-found
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

Remove the Gateway API CRDs:

{{< include "/ngf/installation/uninstall-gateway-api-resources.md" >}}

## See also

- [Gateway API Inference Exntension Introduction](https://gateway-api-inference-extension.sigs.k8s.io/): for introductory details to the project.
- [Gateway API Inference Extension API Overview](https://gateway-api-inference-extension.sigs.k8s.io/concepts/api-overview/): for an API overview.
- [Gateway API Inference Extension User Guides](https://gateway-api-inference-extension.sigs.k8s.io/guides/): for additional use cases and guides.

