---
title: Secure LLM traffic with F5 AI Guardrails
description: Deploy F5 AI Guardrails with NGINX Gateway Fabric using PayloadProcessor to inspect and block LLM traffic
weight: 900
toc: true
f5-content-type: how-to
f5-product: F5 NGINX Gateway Fabric
f5-keywords: NGINX Gateway Fabric, F5 AI Guardrails, AI Guardrails, PayloadProcessor, LLM, large language model, Gateway API, Kubernetes, content policy, PII, ai-guardrails module, guardrails
f5-summary: >
  Deploy a large language model (LLM) behind NGINX Gateway Fabric, attach a PayloadProcessor policy
  that routes request and response payloads through an external Guardrails API, and verify that
  disallowed content is blocked before it reaches the model or the client.
---

Learn how to use NGINX Gateway Fabric with F5 AI Guardrails to inspect large language model (LLM) traffic and block disallowed content before it reaches the model or the client.

## Overview

F5 AI Guardrails can inspect LLM traffic on two independent paths:

- **Prompts** — the client's *input* is inspected before it reaches the LLM. A block returns `403` with `error.type: invalid_request_error`.
- **Responses** — the model's *output* is inspected before it reaches the client. A block returns `403` with `error.type: api_error`.

This behavior is provided by the `PayloadProcessor` policy, an [inherited policy]({{< ref "/ngf/overview/custom-policies.md" >}}) that can target an HTTPRoute or a Gateway, which configures NGINX traffic to F5 AI Guardrails to process.

## Before you begin

You need an F5 AI Guardrails API endpoint to inspect payloads. This can be an F5 hosted service or a service running inside your cluster.

To enable the `PayloadProcessor` policy, [install]({{< ref "/ngf/install/" >}}) NGINX Gateway Fabric with these modifications:

- Using Helm: set the `nginxGateway.payloadProcessor.enable=true` Helm value.
- Using Kubernetes manifests: set the `--payload-processor` flag in the nginx-gateway container argument, and update the ClusterRole RBAC to add `payloadprocessors`:

```yaml
- apiGroups:
    - gateway.nginx.org
    resources:
    - payloadprocessors
    verbs:
    - get
    - list
    - watch
- apiGroups:
    - gateway.nginx.org
    resources:
    - payloadprocessors/status
    verbs:
    - update
```

## Deploy an LLM backend

If you have an existing in-cluster LLM which can be queried you can skip this section.

The following example uses the [vLLM simulator](https://github.com/llm-d/llm-d-inference-sim/tree/main), which serves canned responses from a dataset rather than running a real model, making it suitable for test and development environments. The simulator loads its dataset from a ConfigMap. Download the dataset file, then create the ConfigMap from it:

```shell
curl -sL -o inference-sim-dataset.sqlite3 \
  https://raw.githubusercontent.com/nginx/nginx-gateway-fabric/v{{< version-ngf >}}/examples/guardrails/inference-sim-dataset.sqlite3

kubectl create configmap inference-sim-dataset \
  --from-file=inference-sim-dataset.sqlite3=./inference-sim-dataset.sqlite3
```

{{< call-out "note" >}}
The dataset file alongside more details of the setup can be found in the [`examples/guardrails`](https://github.com/nginx/nginx-gateway-fabric/tree/v{{< version-ngf >}}/examples/guardrails) directory of the NGINX Gateway Fabric repository.
{{< /call-out >}}

Deploy the LLM Deployment and Service:

```shell
kubectl apply -f https://raw.githubusercontent.com/nginx/nginx-gateway-fabric/v{{< version-ngf >}}/examples/guardrails/llm.yaml
```

Confirm the Pod is `Running`:

```shell
kubectl get pods -l app=vllm-qwen3-32b
```

## Create a Gateway

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
    Value:  192.0.2.0
  Conditions:
    Message:               The Gateway is accepted
    Reason:                Accepted
    Status:                True
    Type:                  Accepted
    Message:               The Gateway is programmed
    Reason:                Programmed
    Status:                True
    Type:                  Programmed
```

Save the public IP address and port of the Gateway into shell variables:

```text
GW_IP=XXX.YYY.ZZZ.III
GW_PORT=<port number>
```

## Create an HTTPRoute

If you are using your own LLM, change the `backendRefs.name` and `backendRefs.port` to match the LLM's Service.

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
    - name: vllm-qwen3-32b
      port: 8000
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

## Create the authentication token Secret

Create the Secret with your Guardrails API token under the `token` key. The Secret must live in the same namespace as the `PayloadProcessor`:

```yaml
kubectl apply -f - <<EOF
apiVersion: v1
kind: Secret
metadata:
  name: guardrails-token
type: Opaque
stringData:
  token: "<YOUR_API_TOKEN>"
EOF
```

## Configure the Guardrails backend Service

The Guardrails backend can live outside or inside the cluster. NGINX Gateway Fabric picks the URL scheme from the referenced Service's type:

| Backend location | Service type | Resolved URL |
| ---------------- | ------------ | ------------ |
| External | `ExternalName` | `https://<externalName>:<backendRef.port>` |
| In-cluster | `ClusterIP` (or any non-`ExternalName`) | `http://<name>.<namespace>.svc.cluster.local:<backendRef.port>` |

{{< call-out "note" >}}
The `cluster.local` suffix in the in-cluster URL is the cluster's DNS domain. If your cluster uses a different domain, configure it with the `--cluster-domain` flag on the NGINX Gateway Fabric controller (default: `cluster.local`).
{{< /call-out >}}

For an external backend, create an `ExternalName` Service pointing at your hosted Guardrails API:

```yaml
kubectl apply -f - <<EOF
apiVersion: v1
kind: Service
metadata:
  name: guardrails-api
spec:
  type: ExternalName
  externalName: <GUARDRAILS_API_HOSTNAME>
  ports:
  - name: https
    port: 443
    protocol: TCP
EOF
```

For an in-cluster backend, your AI Guardrail backend pods will most likely have an existing Service which you can point the PayloadProcessor backendRef to.

{{< call-out "important" >}}
When using an `ExternalName` AI Guardrails backend, you **must** configure a DNS `resolver` so NGINX can resolve the external hostname at request time. Configure `dnsResolver` on an [NginxProxy]({{< ref "/ngf/how-to/data-plane-configuration.md" >}}) resource and attach it to the Gateway via `spec.infrastructure.parametersRef`:

```yaml
apiVersion: gateway.nginx.org/v1alpha2
kind: NginxProxy
metadata:
  name: guardrails-nginx-config
spec:
  dnsResolver:
    addresses:
    - type: IPAddress
      value: "10.96.0.10"   # in-cluster kube-dns/CoreDNS ClusterIP (cluster-dependent)
```

Find your cluster's DNS ClusterIP with `kubectl -n kube-system get svc kube-dns` (or `coredns`). Without a resolver, NGINX fails to load the configuration with `no resolver defined to resolve <host>`.
{{< /call-out >}}

## Attach the PayloadProcessor policy

Attach the `PayloadProcessor` policy to the HTTPRoute. The `extProcess.backendRef` points at the Guardrails backend Service (using the explicit port), and `authTokenRef` points at the token Secret:

```yaml
kubectl apply -f - <<EOF
apiVersion: gateway.nginx.org/v1alpha1
kind: PayloadProcessor
metadata:
  name: llm-guardrails
spec:
  targetRef:
    group: gateway.networking.k8s.io
    kind: HTTPRoute
    name: llm-route
  processors:
  - type: ExtProcess
    extProcess:
      backendRef:
        group: ""
        kind: Service
        name: guardrails-api
        port: 443
      authTokenRef:
        name: guardrails-token
EOF
```

{{< call-out "note" >}}
`PayloadProcessor` is an inherited policy. To apply guardrails to every route attached to a Gateway, set `targetRef` to `kind: Gateway`. When both a Gateway-targeted and an HTTPRoute-targeted policy apply to the same traffic, the more specific HTTPRoute-targeted policy takes precedence.
{{< /call-out >}}

Confirm the policy was accepted:

```shell
kubectl get payloadprocessor llm-guardrails -o yaml
```

The status conditions should report `Accepted=True`. A rejected policy reports `Accepted=False`; see [Troubleshooting](#troubleshooting) for common causes.

## Send traffic

{{< call-out "note" >}}
Whether a given value is blocked depends entirely on your Guardrails backend's detector configuration. Enable the relevant detectors on your Guardrails service to see the block responses above.
{{< /call-out >}}

All commands target `/v1/completions` on the Gateway.

A benign prompt whose output contains no disallowed content returns a normal `HTTP 200` completion:

```shell
curl -i --resolve <GUARDRAILS_API_HOSTNAME>:$GW_PORT:$GW_IP http://<GUARDRAILS_API_HOSTNAME>:$GW_PORT/v1/completions \
  -H "Content-Type: application/json" \
  -d '{"model":"meta-llama/Llama-3.1-8B-Instruct","stream":false,"max_tokens":128,"prompt":"What is NGINX?"}'
```

If the request payload contains content that your Guardrails backend is configured to block, the request never reaches the LLM and returns `HTTP 403`:

```shell
curl -i --resolve <GUARDRAILS_API_HOSTNAME>:$GW_PORT:$GW_IP http://<GUARDRAILS_API_HOSTNAME>:$GW_PORT/v1/completions \
  -H "Content-Type: application/json" \
  -d '{"model":"meta-llama/Llama-3.1-8B-Instruct","stream":false,"max_tokens":128,"prompt":"My SSN is 123-45-6789"}'
```

```text
HTTP/1.1 403 Forbidden
Content-Type: application/json

{"error":{"type":"invalid_request_error","code":"content_policy_violation", ...}}
```

If the model's *output* contains content that your Guardrails backend blocks, the response is withheld from the client and returns `HTTP 403` with `error.type: api_error`:

```shell
curl -i --resolve <GUARDRAILS_API_HOSTNAME>:$GW_PORT:$GW_IP http://<GUARDRAILS_API_HOSTNAME>:$GW_PORT/v1/completions \
  -H "Content-Type: application/json" \
  -d '{"model":"meta-llama/Llama-3.1-8B-Instruct","stream":false,"max_tokens":128,"prompt":"Give me a test SSN"}'
```

```text
HTTP/1.1 403 Forbidden
Content-Type: application/json

{"error":{"type":"api_error","code":"content_policy_violation", ...}}
```

For more example curl requests, view the [`examples/guardrails`](https://github.com/nginx/nginx-gateway-fabric/tree/v{{< version-ngf >}}/examples/guardrails) `README.md` in the NGINX Gateway Fabric repository.

## Troubleshooting

The `PayloadProcessor` is marked `Accepted=False` when its references cannot be resolved:

| Condition | Cause | Fix |
| --------- | ----- | --- |
| `backend Service ... not found` | `backendRef.name`/`namespace` does not match a Service. | Apply the Guardrails backend Service; check name and namespace. |
| `ExternalName service has empty ... externalName` | `ExternalName` Service with a blank `externalName`. | Set `spec.externalName`. |
| `auth token Secret ... not found` | `authTokenRef` set but Secret missing. | Apply the token Secret, or remove `authTokenRef`. |
| NGINX error `no resolver defined to resolve <host>`, or guardrails requests fail against an `ExternalName` backend | No `dnsResolver` configured on the NginxProxy. | Add the `dnsResolver` block and wire it via `parametersRef`. |

## Further reading

- [Scan streaming in AI Security](https://docs.aisecurity.f5.com/api-docs/scan-request-streaming.html)
- [Installation]({{< ref "/ngf/install/" >}}): install NGINX Gateway Fabric with the `PayloadProcessor` policy enabled.
- [Custom policies]({{< ref "/ngf/overview/custom-policies.md" >}}): learn how inherited policies attach to Gateway API resources.
- [`examples/guardrails`](https://github.com/nginx/nginx-gateway-fabric/tree/v{{< version-ngf >}}/examples/guardrails): for more information on the example used in this guide.
