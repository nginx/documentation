---
description: Monitor the health of gRPC servers in an upstream group by sending periodic
  health checks.
docs: DOCS-416
title: gRPC Health Checks
toc: true
weight: 600
type:
- how-to
---

<span id="intro"></span>
## Introduction
F5 NGINX Plus can monitor the health of upstream servers by making active health checks. NGINX Plus R23 supports the [gRPC health checking protocol](https://github.com/grpc/grpc/blob/master/doc/health-checking.md#grpc-health-checking-protocol) so that upstream gRPC services can be tested for their ability to handle new requests. This is particularly important in dynamic and containerized environments. When adding a new instance of a gRPC service, it is important that requests are sent to the fully operating service.

<span id="prereq"></span>
## Prerequisites

- You have configured an upstream group of servers that handles gRPC network traffic and specified a shared memory zone that keeps the state of these servers, for example:

   ```nginx
   stream {
       #...
       upstream grpc_backend {
           zone   grpc_backend 64k;
           server 10.0.0.1:50051;
           server 10.0.0.2:50051;
       }
       #...
   }
   ```

- You have configured a server that routes gRPC requests to the upstream server group:

   ```nginx
   location /grpc {
       grpc_pass grpc://grpc_backend;
   }
   ```

<span id="hc_grpc"></span>
## gRPC Servers that accept health checking protocol

If your gRPC services support the gRPC health checking protocol, specify the [`type=grpc`](https://nginx.org/en/docs/http/ngx_http_upstream_hc_module.html#health_check_grpc) parameter of the `health_check` directive:

```nginx
location / {
    grpc_pass    grpc://grpc_backend;
    health_check mandatory type=grpc;
}
```

In this example, according to health checking protocol, the `Check` method of the `Health` service will be invoked, and the gRPC server that respond with `SERVING` are considered healthy.

The `mandatory` parameter ensures that the health check must pass before traffic is sent on an instance, for example, when it is introduced or reloaded.  Note that the `type=grpc` must be specified after all other `health_check` parameters.

If there are several gRPC services exposed on each upstream server then the most significant service can be monitored by specifying the service name with the `grpc_service` parameter:

```nginx
location / {
    grpc_pass    grpc://grpc_backend;
    health_check mandatory type=grpc grpc_service=MyStatus;
}
```

<span id="hc_grpc_status"></span>
## gRPC Servers that do not accept health checking protocol

If your gRPC services do not implement the gRPC health checking protocol, it is still possible to perform health check by sending the `Check` method and expecting a particular [`status code`](https://github.com/grpc/grpc/blob/master/doc/statuscodes.md#status-codes-and-their-use-in-grpc). This will test that the upstream server is responding to gRPC requests. Specify the gRPC error response code with the `grpc_status` parameter:

```nginx
location / {
    grpc_pass    grpc://grpc_backend;
    health_check type=grpc grpc_status=12; # 12=unimplemented
}
```

In this case the response with the gRPC status of `12` / `UNIMPLEMENTED` will be considered healthy.

Note that the `type=grpc` parameter is not compatible with `uri` or `match` parameters of the `health_check` directive. The `type=grpc` parameter must be specified after all other directive parameters: `grpc_service` and `grpc_status` must follow `type=grpc`.

<span id="see_also"></span>
## See also

- [Deploying NGINX Plus as an API Gateway, Part 3: Publishing gRPC Services](https://www.nginx.com/blog/deploying-nginx-plus-as-an-api-gateway-part-3-publishing-grpc-services/)
