---
---

{{< call-out "important" >}}

You can view the [Milestone Roadmap](https://github.com/orgs/nginx/projects/10/views/5) in the NGINX Gateway Fabric GitHub project to see what API resources will be supported in upcoming releases.

{{< /call-out >}}

{{< table >}}

| Resource                              | Core Support Level  | Extended Support Level | Implementation-Specific Support Level | API Version | API Release Channel |
|---------------------------------------|---------------------|------------------------|---------------------------------------|-------------|---------------------|
| [GatewayClass]({{< ref "/ngf/overview/gateway-api-compatibility.md#gatewayclass" >}})         | Supported     | Not supported          | Supported           | v1          | Standard     |
| [Gateway]({{< ref "/ngf/overview/gateway-api-compatibility.md#gateway" >}})                   | Supported     | Partially supported    | Not supported       | v1          | Standard     |
| [HTTPRoute]({{< ref "/ngf/overview/gateway-api-compatibility.md#httproute" >}})               | Supported     | Partially supported    | Not supported       | v1          | Standard     |
| [GRPCRoute]({{< ref "/ngf/overview/gateway-api-compatibility.md#grpcroute" >}})               | Supported     | Partially supported    | Not supported       | v1          | Standard     |
| [ReferenceGrant]({{< ref "/ngf/overview/gateway-api-compatibility.md#referencegrant" >}})     | Supported     | N/A                    | Not supported       | v1beta1     | Standard     |
| [TLSRoute]({{< ref "/ngf/overview/gateway-api-compatibility.md#tlsroute" >}})                 | Supported     | Not supported          | Not supported       | v1alpha2    | Experimental |
| [TCPRoute]({{< ref "/ngf/overview/gateway-api-compatibility.md#tcproute" >}})                 | Supported | Supported          | Not supported       | v1alpha2    | Experimental |
| [UDPRoute]({{< ref "/ngf/overview/gateway-api-compatibility.md#udproute" >}})                 | Supported | Supported          | Not supported       | v1alpha2    | Experimental |
| [BackendTLSPolicy]({{< ref "/ngf/overview/gateway-api-compatibility.md#backendtlspolicy" >}}) | Partially supported     | Supported              | Partially supported | v1          | Standard     |
| [Custom policies]({{< ref "/ngf/overview/gateway-api-compatibility.md#custom-policies" >}})   | N/A           | N/A                    | Supported           | N/A         | N/A          |

{{< /table >}}