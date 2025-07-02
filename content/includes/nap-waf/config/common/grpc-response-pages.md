---
nd-docs: "DOCS-1597"
---

A gRPC error response page is returned when a request is blocked. The default page returns gRPC status code `UNKNOWN` (numeric value of 2) and a short textual message that includes the support ID. You can customize any of these two by configuring a custom gRPC response page in your policy.

```json
{
    "policy": {
        "name": "my-special-grpc-service-policy",
        "response-pages": [
            {
                "responsePageType": "grpc",
                "grpcStatusCode": "INVALID_ARGUMENT",
                "grpcStatusMessage": "Operation does not comply with the service requirements. Please contact your administrator with the following number: <%TS.request.ID()%>"
            }
        ]
    }
}
```

The `grpcStatusCode` expects one of the [standard gRPC status code values](https://grpc.github.io/grpc/core/md_doc_statuscodes.html).