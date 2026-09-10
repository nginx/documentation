---
title: Secure LLM traffic with F5 AI Guardrails
description: Deploy F5 AI Guardrails with NGINX Gateway Fabric using PayloadProcessor to inspect and block LLM traffic
weight: 900
toc: true
f5-content-type: how-to
f5-product: F5 NGINX Gateway Fabric
f5-keywords: NGINX Gateway Fabric, F5 AI Guardrails, AI Guardrails, PayloadProcessor, LLM, large language model, Gateway API, Kubernetes, content policy, PII, ai-guardrails module, guardrails, BackendTLSPolicy, client_body_buffer_size, ClientSettingsPolicy
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
- **Oversized prompts** — a prompt too large to inspect in memory is blocked before it reaches the LLM. A block returns `403` with `error.type: request_too_large` (`code: request_body_too_large`).

You can set up prompts and responses as described in [Prompts and scans in AI Security](https://docs.aisecurity.f5.com/api-docs/prompts-scans.html), through the F5 AI Guardrails dashboard.

To connect NGINX Gateway Fabric with your configured F5 AI Guardrails, use the `PayloadProcessor` policy, an [inherited policy]({{< ref "/ngf/overview/custom-policies.md" >}}) that can target an HTTPRoute or a Gateway. The `PayloadProcessor` configures NGINX to offload traffic to F5 AI Guardrails to inspect.

{{< call-out "note" >}}
The PayloadProcessor CRD is inspired by the proposed resource from the Gateway API AI Gateway Working Group, which is subject to change and may be redefined in future releases. Consider this experimental while it is being defined by the Gateway API WG.
{{< /call-out >}}

{{< call-out "note" >}}
When AI Guardrails are enabled on a route, NGINX Gateway Fabric strips the Accept-Encoding header from requests sent to the upstream backend. This ensures responses are returned uncompressed so the F5 AI Guardrails filter can inspect them. Compression between NGINX and the client is unaffected. NGINX can still compress responses to clients via its gzip module.
{{< /call-out >}}

## Before you begin

You need an F5 AI Guardrails API endpoint to inspect payloads. This can be an F5 hosted service or a service running inside your cluster. View the official [F5 AI Guardrails](https://docs.aisecurity.f5.com/) docs to learn more.

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
The dataset file, alongside more details of the setup, can be found in the [`examples/guardrails`](https://github.com/nginx/nginx-gateway-fabric/tree/v{{< version-ngf >}}/examples/guardrails) directory of the NGINX Gateway Fabric repository.
{{< /call-out >}}

Deploy the LLM Deployment and Service:

```shell
kubectl apply -f https://raw.githubusercontent.com/nginx/nginx-gateway-fabric/v{{< version-ngf >}}/examples/guardrails/llm.yaml
```

Confirm the Pod is `Ready`:

```shell
kubectl get deployment vllm-qwen3-32b
```

```text
NAME             READY   UP-TO-DATE   AVAILABLE   AGE
vllm-qwen3-32b   1/1     1            1           6m13s
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

The Guardrails backend can live outside or inside the cluster. NGINX Gateway Fabric picks the URL scheme from the referenced Service's type and from any BackendTLSPolicy that targets the Service.

| Backend location | Service type | BackendTLSPolicy targeting the Service | Resolved URL |
| ---------------- | ------------ | -------------------------------------- | ------------ |
| External | `ExternalName` | Ignored | `https://<externalName>:<backendRef.port>` (verified against the system trust store) |
| In-cluster | `ClusterIP` (or any non-`ExternalName`) | None | `http://<name>.<namespace>.svc.cluster.local:<backendRef.port>` |
| In-cluster | `ClusterIP` (or any non-`ExternalName`) | Present and valid | `https://<name>.<namespace>.svc.cluster.local:<backendRef.port>` (verified against the policy's CA certificate) |

{{< call-out "note" >}}
The `cluster.local` suffix in the in-cluster URL is the cluster's DNS domain. If your cluster uses a different domain, configure it with the `--cluster-domain` flag or `clusterDomain` Helm value when deploying NGINX Gateway Fabric (default: `cluster.local`).
{{< /call-out >}}

{{<tabs name="guardrails-backend-location">}}

{{%tab name="External"%}}

To configure a Guardrails backend Service which is external, create an `ExternalName` Service pointing at your hosted Guardrails API:

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

{{% /tab %}}

{{%tab name="In-cluster"%}}

For an in-cluster backend, your AI Guardrail backend pods will most likely have an existing Service which you can point the PayloadProcessor backendRef to, otherwise create a Service configured to expose your guardrail backends:

```yaml
kubectl apply -f - <<EOF
apiVersion: v1
kind: Service
metadata:
  name: guardrails-api
spec:
  ports:
  - name: http
    port: 443
    protocol: TCP
  selector:
    guardrails-backend-key: guardrails-backend-value
EOF
```

{{% /tab %}}

{{</tabs>}}

{{< call-out "important" >}}
When using an `ExternalName` AI Guardrails backend, you **must** configure a DNS `resolver` so NGINX can resolve the external hostname at request time. Either edit the NginxProxy which gets created when you deploy NGINX Gateway Fabric, or configure `dnsResolver` on a new [NginxProxy]({{< ref "/ngf/how-to/data-plane-configuration.md" >}}) resource and attach it to the Gateway via `spec.infrastructure.parametersRef`:

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

### Secure an in-cluster backend with TLS

Encrypt and verify traffic to an in-cluster Guardrails backend, including a backend whose serving certificate is signed by a custom or self-signed certificate authority (CA) with no public root.

Without a `BackendTLSPolicy`, an in-cluster backend is reached over plaintext `http`, as the Resolved URL table above shows. The payloads sent for inspection can carry sensitive content, such as the SSN in the examples below, so a `BackendTLSPolicy` encrypts and verifies that path instead of leaving it unencrypted across the cluster network.

A `BackendTLSPolicy` is a Gateway API policy (`gateway.networking.k8s.io/v1`) that tells NGINX Gateway Fabric to verify a backend Service's TLS certificate. Attach one to the Guardrails Service, and NGINX Gateway Fabric switches that backend from `http` to `https`.

Before you continue, make sure you have:

- A PEM-encoded CA certificate (`ca.crt`) that signed the backend's serving certificate.
- A backend that serves TLS on a known port.

Create a ConfigMap from your CA certificate, where `./ca.crt` is your own CA file. The ConfigMap must live in the backend Service's namespace:

```shell
kubectl create configmap guardrails-ca --from-file=ca.crt=./ca.crt -n <namespace>
```

This Service and `BackendTLSPolicy` replace the plaintext in-cluster Service from the In-cluster tab, reusing the name `guardrails-api` on the TLS port. If you already applied that plaintext Service, reapply it with the manifest below.

Create the TLS Service and a `BackendTLSPolicy` that targets it. Set `validation.hostname` to the Service FQDN. NGINX Gateway Fabric uses this value for SNI (Server Name Indication), the Host header, and certificate hostname verification:

```yaml
kubectl apply -f - <<EOF
apiVersion: v1
kind: Service
metadata:
  name: guardrails-api
spec:
  selector:
    guardrails-backend-key: guardrails-backend-value
  ports:
  - name: https
    port: 8443
    targetPort: 8443
    protocol: TCP
---
apiVersion: gateway.networking.k8s.io/v1
kind: BackendTLSPolicy
metadata:
  name: guardrails-api-tls
spec:
  targetRefs:
  - group: ""
    kind: Service
    name: guardrails-api
  validation:
    caCertificateRefs:
    - group: ""
      kind: ConfigMap
      name: guardrails-ca
    hostname: guardrails-api.<namespace>.svc.cluster.local
EOF
```

Replace `<namespace>` with the namespace of the backend Service. The `validation.hostname` must match the Service FQDN. Set the `PayloadProcessor`'s `backendRef` to this Service in the same namespace.

Confirm the policy was accepted:

```shell
kubectl describe backendtlspolicies.gateway.networking.k8s.io guardrails-api-tls
```

The status conditions should report `Accepted=True` and `ResolvedRefs=True`. NGINX Gateway Fabric switches the backend to `https` only after the policy is accepted.

```text
Conditions:
      Last Transition Time:  2026-08-11T17:34:10Z
      Message:               All CACertificateRefs are resolved
      Observed Generation:   1
      Reason:                ResolvedRefs
      Status:                True
      Type:                  ResolvedRefs
      Last Transition Time:  2026-08-11T17:34:10Z
      Message:               The Policy is accepted
      Observed Generation:   1
      Reason:                Accepted
      Status:                True
      Type:                  Accepted
    Controller Name:         gateway.nginx.org/nginx-gateway-controller
```

{{< call-out "note" >}}
Set the `PayloadProcessor` `backendRef.port` to the TLS Service port, for example `8443`, so the URL resolves to `https://guardrails-api.<namespace>.svc.cluster.local:8443`.
{{< /call-out >}}

Keep these rules in mind when securing the in-cluster path:

- NGINX Gateway Fabric picks the scheme per Gateway. The same `PayloadProcessor` can resolve to `https` on one Gateway and plaintext `http` on another, depending on whether a `BackendTLSPolicy` is effective for that Gateway.
- A `BackendTLSPolicy` that targets an `ExternalName` Guardrails Service is ignored. An `ExternalName` backend is always verified against the system trust store.
- The in-cluster HTTPS path needs no DNS resolver, unlike the `ExternalName` path.
- To revert an in-cluster backend to plaintext `http`, remove the `BackendTLSPolicy` that targets its Service.

{{< call-out "important" >}}
NGINX Gateway Fabric fails closed when a `BackendTLSPolicy` targeting the backend Service is invalid, or when the CA ConfigMap it references is missing. The `PayloadProcessor` is not programmed for that backend, and NGINX Gateway Fabric does not fall back to plaintext.
{{< /call-out >}}

## Deploy NGINX Gateway Fabric

[Install]({{< ref "/ngf/install/" >}}) NGINX Gateway Fabric with the `PayloadProcessor` policy enabled:

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

```text
Conditions:
      Last Transition Time:  2026-08-11T17:29:19Z
      Message:               The Route is accepted
      Observed Generation:   1
      Reason:                Accepted
      Status:                True
      Type:                  Accepted
      Last Transition Time:  2026-08-11T17:29:19Z
      Message:               All references are resolved
      Observed Generation:   1
      Reason:                ResolvedRefs
      Status:                True
      Type:                  ResolvedRefs
    Controller Name:         gateway.nginx.org/nginx-gateway-controller
```

## Attach the PayloadProcessor policy

Attach the `PayloadProcessor` policy to the HTTPRoute. The `extProcess.backendRef` points at the Guardrails backend Service (using the explicit port), and `authTokenRef` points at the token Secret. For an in-cluster HTTPS backend, set `backendRef.port` to the TLS Service port instead of `443` (see [Secure an in-cluster backend with TLS](#secure-an-in-cluster-backend-with-tls)):

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
        port: 443  # in-cluster HTTPS: use the TLS Service port, for example 8443
      authTokenRef:
        name: guardrails-token
EOF
```

{{< call-out "note" >}}
`PayloadProcessor` is an inherited policy. To apply guardrails to every route attached to a Gateway, set `targetRef` to `kind: Gateway`. When both a Gateway-targeted and an HTTPRoute-targeted policy apply to the same traffic, the more specific HTTPRoute-targeted policy takes precedence.
{{< /call-out >}}

Confirm the policy was accepted:

```shell
kubectl describe payloadprocessor llm-guardrails
```

The status conditions should report `Accepted=True`. A rejected policy reports `Accepted=False`; see [Troubleshooting](#troubleshooting) for common causes.

```text
Conditions:
      Last Transition Time:  2026-08-11T17:32:52Z
      Message:               The Policy is accepted
      Observed Generation:   1
      Reason:                Accepted
      Status:                True
      Type:                  Accepted
      Last Transition Time:  2026-08-11T17:32:52Z
      Message:               Policy is programmed in the data plane
      Observed Generation:   1
      Reason:                Programmed
      Status:                True
      Type:                  Programmed
    Controller Name:         gateway.nginx.org/nginx-gateway-controller
```

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

```text
HTTP/1.1 200 OK
Server: nginx
Date: Tue, 11 Aug 2026 17:39:19 GMT
Content-Type: application/json
Content-Length: 607
Connection: keep-alive
X-Inference-Pod: vllm-qwen3-32b-58cfff7c9-5zlm2
X-Inference-Port: 8000

{"id":"cmpl-f657bc1b-c50c-5a5c-9408-45bd22a150a1","created":1786469959,"model":"meta-llama/Llama-3.1-8B-Instruct","usage":{"prompt_tokens":4,"completion_tokens":62,"total_tokens":66},"object":"text_completion","kv_transfer_params":null,"choices":[{"index":0,"finish_reason":"stop","text":"NGINX (pronounced \"engine-x\") is an open-source, high-performance web server. It functions primarily as an HTTP web server, reverse proxy, load balancer, and HTTP cache.Designed to handle thousands of concurrent connections with minimal memory usage, NGINX is an essential component of modern web infrastructure."}]
```

If the request payload contains content that your Guardrails backend is configured to block, the request never reaches the LLM and returns `HTTP 403`:

```shell
curl -i --resolve <GUARDRAILS_API_HOSTNAME>:$GW_PORT:$GW_IP http://<GUARDRAILS_API_HOSTNAME>:$GW_PORT/v1/completions \
  -H "Content-Type: application/json" \
  -d '{"model":"meta-llama/Llama-3.1-8B-Instruct","stream":false,"max_tokens":128,"prompt":"My SSN is 123-45-6789"}'
```

```text
HTTP/1.1 403 Forbidden
Server: nginx
Date: Tue, 11 Aug 2026 17:39:50 GMT
Content-Length: 139
Connection: keep-alive
Content-Type: application/json

{"error":{"code":"content_policy_violation","message":"Request blocked by guardrails policy.","param":null,"type":"invalid_request_error"}
```

If the model's *output* contains content that your Guardrails backend blocks, the response is withheld from the client and returns `HTTP 403` with `error.type: api_error`:

```shell
curl -i --resolve <GUARDRAILS_API_HOSTNAME>:$GW_PORT:$GW_IP http://<GUARDRAILS_API_HOSTNAME>:$GW_PORT/v1/completions \
  -H "Content-Type: application/json" \
  -d '{"model":"meta-llama/Llama-3.1-8B-Instruct","stream":false,"max_tokens":128,"prompt":"Give me a test SSN"}'
```

```text
HTTP/1.1 403 Forbidden
Server: nginx
Date: Tue, 11 Aug 2026 17:40:36 GMT
Content-Type: application/json
Content-Length: 128
Connection: keep-alive
X-Inference-Pod: vllm-qwen3-32b-58cfff7c9-5zlm2
X-Inference-Port: 8000

{"error":{"code":"content_policy_violation","message":"Response blocked by guardrails policy.","param":null,"type":"api_error"}}
```

{{< call-out "note" >}}
The ai-guardrails module inspects only the request body held in memory. When a prompt is larger than `client_body_buffer_size`, NGINX writes it to a temporary file that the module can't inspect. NGINX Gateway Fabric then fails closed with `403`, `error.type: request_too_large`, and `code: request_body_too_large`. To let large prompts stay in memory, raise `client_body_buffer_size` through a `ClientSettingsPolicy` (field `spec.body.bufferSize`). A larger buffer increases the memory NGINX uses per request. See [Client settings]({{< ref "/ngf/traffic-management/client-settings.md" >}}) for the field and its default.
{{< /call-out >}}

For more example curl requests, view the [`examples/guardrails`](https://github.com/nginx/nginx-gateway-fabric/tree/v{{< version-ngf >}}/examples/guardrails) `README.md` in the NGINX Gateway Fabric repository.

## Troubleshooting

The `PayloadProcessor` is marked `Accepted=False` when its references cannot be resolved:

| Condition | Cause | Fix |
| --------- | ----- | --- |
| `backend Service ... not found` | `backendRef.name`/`namespace` does not match a Service. | Apply the Guardrails backend Service; check name and namespace. |
| `ExternalName service has empty ... externalName` | `ExternalName` Service with a blank `externalName`. | Set `spec.externalName`. |
| `auth token Secret ... not found` | `authTokenRef` set but Secret missing. | Apply the token Secret, or remove `authTokenRef`. |
| NGINX error `no resolver defined to resolve <host>`, or guardrails requests fail against an `ExternalName` backend | No `dnsResolver` configured on the NginxProxy. | Add the `dnsResolver` block and wire it via `parametersRef`. |
| `403` with `error.type: request_too_large` (`code: request_body_too_large`) | The prompt exceeded `client_body_buffer_size`. The module inspects only the in-memory body and fails closed. | Raise `client_body_buffer_size` with a `ClientSettingsPolicy`. See [Client settings]({{< ref "/ngf/traffic-management/client-settings.md" >}}). |
| An in-cluster HTTPS backend's `PayloadProcessor` isn't programmed | The `BackendTLSPolicy` targeting the backend Service is invalid, or its referenced CA ConfigMap is missing. NGINX Gateway Fabric fails closed rather than using plaintext. | Correct the `BackendTLSPolicy`. Make sure the CA ConfigMap holding `ca.crt` exists in the Service's namespace. |

## Further reading

- [Scan streaming in AI Security](https://docs.aisecurity.f5.com/api-docs/scan-request-streaming.html)
- [Installation]({{< ref "/ngf/install/" >}}): install NGINX Gateway Fabric with the `PayloadProcessor` policy enabled.
- [Custom policies]({{< ref "/ngf/overview/custom-policies.md" >}}): learn how inherited policies attach to Gateway API resources.
- [Client settings]({{< ref "/ngf/traffic-management/client-settings.md" >}}): configure `client_body_buffer_size` and other client connection settings.
- [Gateway API BackendTLSPolicy](https://gateway-api.sigs.k8s.io/reference/api-types/policy/backendtlspolicy/): reference for the BackendTLSPolicy resource.
- [Secure backend traffic with mutual TLS]({{< ref "/ngf/traffic-security/secure-backend.md" >}}): encrypt traffic between the Gateway and a backend using BackendTLSPolicy and mutual TLS.
- [`examples/guardrails`](https://github.com/nginx/nginx-gateway-fabric/tree/v{{< version-ngf >}}/examples/guardrails): for more information on the example used in this guide.
