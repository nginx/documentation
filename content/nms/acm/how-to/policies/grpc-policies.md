---
description: Learn how to use F5 NGINX Management Suite API Connectivity Manager to
  configure policies for your gRPC API Gateway.
docs: DOCS-1084
toc: true
weight: 600
title: gRPC
type:
- how-to
---

{{< shortversions "1.3.0" "latest" "acmvers" >}}

## Overview

{{< include "acm/how-to/policies-intro.md" >}}

Refer to the [Set Up Policies]({{< relref "/nms/acm/how-to/policies/manage-policies.md" >}}) topic for instructions on how to configure policies for your API Gateway and Developer Portal clusters and API Proxies.

---

## Global Policies

### Return Default gRPC Status Codes {#grpc-status-codes}

The default NGINX error pages are suitable for conventional HTTP traffic.  gRPC clients, however, expect [gRPC responses](https://github.com/grpc/grpc/blob/master/doc/statuscodes.md).

To return default gRPC status codes, send a POST request to the Environments endpoint.


{{<bootstrap-table "table">}}

| Method | Endpoint                                                |
|--------|---------------------------------------------------------|
| POST   | `/infrastructure/workspaces/<INFRA_WORKSPACE_NAME>/environments` |

{{</bootstrap-table>}}


<details open>
<summary>Example JSON request</summary>

```json
{
    "name": "{{environmentname}}",
    "type": "NON-PROD",
    "functions": [
        "API-GATEWAY"
    ],
    "proxies": [
        {
            "proxyClusterName": "{{instanceGroupName}}",
            "hostnames": [
                "{{environmentHostname}}"
            ],
            "runtime": "GATEWAY-PROXY",
            "listeners": [
                {
                    "port": 8085,
                    "transportProtocol": "GRPC"
                }
            ],
            "policies": {
                "error-response-format": [
                    {
                        "action": {
                            "400": {
                                "errorCode": "13",
                                "grpcStatusCode": 5,
                                "errorMessage": "Bad Request"
                            }
                        }
                    }
                ]
            }
        }
    ]
}
```

</details>

### Log Format {#grpc-log-format}

Use the following variables to log gRPC-specific information. These variables are enabled by default for gRPC APIs.

{{<bootstrap-table "table table-striped table-bordered">}}

| Variable      | Description                                                                                                          |
|---------------|----------------------------------------------------------------------------------------------------------------------|
| `grpcMethod`  | The RPC method invoked in the call.                                                                                  |
| `grpcService` | The service; for example, `routeguide.RouteGuide`                                                                    |
| `grpcStatus`  | The gRPC [status code](https://github.com/grpc/grpc/blob/master/doc/statuscodes.md) returned by the upstream server. |
| `grpcMessage` | The `grpc-message` trailer/header                                                                                    |

{{< /bootstrap-table >}}

Take note of the following considerations when using these standard log format variables for logging gRPC details:

- `requestURI` - This is the relative URI of the gRPC method.  The HTTP2 `:path` pseudo-header is used for this.
- `timestamp` - For streaming methods, this value reflects when the stream is closed.
- `totalLatency` - For streaming methods, this value reflects the entire duration of the stream.
- `bodySize` - For streaming methods, this value counts all of the bytes sent during the duration of the stream and not for individual messages.

### Request Body Size Limit

For streaming methods, the request body size limit is enforced on the entire stream, not per individual message. Therefore, we recommend configuring the limit to be very large or disabling this policy altogether for long-lived streams.

---

## API Proxy Policies

### Auth Policies

The following policies involve some degree of header reading and modifying depending on their configuration and work the same with [gRPC metadata](https://grpc.io/docs/what-is-grpc/core-concepts/#metadata):

- API Key
- Basic Auth
- JWT Assertion
- OAuth2 Introspection

Select `header` for any policy setting that configures the supplied-in value.

For example, suppose the `Authorization` header is used for the API Key authentication, and credential forwarding has been enabled. In that case, the following example Go server code can access that value in the metadata as shown below:

```go
// GetFeature returns the feature at the given point.
func (s *routeGuideServer) GetFeature(ctx context.Context, point *pb.Point) (*pb.Feature, error) {
md, _ := metadata.FromIncomingContext(ctx)
fmt.Printf("Authorization: %+v\n", md.Get("Authorization"))
```

You can also modify these policies' error return conditions, so they return custom gRPC status codes.

### Backend Configuration

There is a separate policy for configuring upstream connection behavior specifically for the gRPC backend service.

- In the web Interface, select the **Backend Config** policy.
- In the REST API, use the `grpc-backend-config` policy.

By default, the following actions have a configured timeout of 7 days:

- Reading client request headers (`client_header_timeout`)
- Reading client request body (`client_body_timeout`)
- Reading a response from the upstream gRPC server (`grpc_read_timeout`)
- Transmitting a request to the upstream gRPC server (`grpc_send_timeout`)

You can configure this policy to override most of these values.

### Health Check

gRPC-specific health checks can be configured for backends that implement the [official protocol](https://github.com/grpc/grpc/blob/master/doc/health-checking.md), as well as those that don't by using an [unimplemented status code](https://docs.nginx.com/nginx/admin-guide/load-balancer/grpc-health-check/#grpc-servers-that-do-not-accept-health-checking-protocol).

Conventional HTTP-based health checks can also be configured, but they cannot be used alongside gRPC healthchecks.

### Customize gRPC Status Codes

You can customize the following policies' [gRPC status code](https://github.com/grpc/grpc/blob/master/doc/statuscodes.md) values:

- Rate Limit
- API Key
- Basic Auth
- JWT Assertion
- OAuth2 Introspection
- ACL IP
- TLS Inbound
- Request Body Size Limit

- In the web interface, any policy which contains *Error Handling* properties accepts `grpcStatusCode` rather than HTTP `returnCode`.
- In the API, any policy with the `errorReturnConditions` object that contains a `returnCode` property, or a `returnCode` property at the top level, accepts a `grpcStatusCode` instead of or in addition to `returnCode`.

    <details open>
    <summary>Example JSON request</summary>

    ```json
    "policies": {
        "acl-ip": [
            {
                "action": {
                    "allow": ["10.0.0.2"],
                    "grpcStatusCode": 13
                }
            }
        ]
    }
    ```

    </details>

### Unsupported Policies

The following policies are not supported at this time:

- Proxy Cache
- CORS
- Allow HTTP Method
