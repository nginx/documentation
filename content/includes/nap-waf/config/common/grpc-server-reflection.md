---
nd-docs: "DOCS-1610"
---

[gRPC Server Reflection](https://grpc.github.io/grpc/core/md_doc_server_reflection_tutorial.html) provides information about publicly-accessible gRPC services on a server, and assists clients at runtime to construct RPC requests and responses without precompiled service information. gRPC Server reflection is not currently supported in App Protect. If Server Reflection support is required, App Protect must be disabled on the reflection URIs by adding a location block such as this:

```nginx
server {
    location /grpc.reflection {
        app_protect_enable off;
        grpc_pass grpc://grpc_backend;
    }
}
```