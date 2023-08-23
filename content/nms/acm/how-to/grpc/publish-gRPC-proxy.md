---
title: "Publish a gRPC Proxy"
# Description
# Add a short description (150 chars) for the doc. Include keywords for SEO. 
# The description text appears in search results and at the top of the doc.
description: "Learn how to use NGINX Management Suite API Connectivity Manager to publish a gRPC Proxy and manage traffic to gRPC services."
# Assign weights in increments of 100
weight: 300
toc: true
categories: ["API Connectivity Manager", "API Proxy", "gRPC"]
doctypes: ["task"]
tags: [ "docs" ]
# Create a new entry in the Jira DOCS Catalog and add the ticket ID (DOCS-<number>) below
docs: "DOCS-997"
---

{{< custom-styles >}}

{{< shortversions "1.2.0" "latest" "acmvers" >}}

## Overview

gRPC has emerged as an alternative approach to building distributed applications, particularly microservice applications. API Connectivity Manager supports publishing gRPC services. 

#### Setup gRPC Echo Server (Optional)
This section details how to setup a gRPC echo server, this can be used to confirm that the gRPC API is working as expected.

From a command line terminal:
1. Create a virtual environment and install the required packages:

```shell
virtualenv echo-servers
source echo-server/bin/activate
pip install grpcio protobuf grpcio-tools
```
2. Create a file called `helloworld.proto` and add the following:

```shell

```shell
syntax = "proto3";

package helloworld;

service Greeter {
    rpc SayHello (HelloRequest) returns (HelloReply) {}
    rpc SayGoodbye (GoodbyeRequest) returns (GoodbyeReply) {}
}

message HelloRequest {
    string name = 1;
}

message HelloReply {
    string message = 1;
}

message GoodbyeRequest {
    string name = 1;
}

message GoodbyeReply {
    string message = 1;
}

```
6. Generate the python code `python -m grpc_tools.protoc -I. --python_out=. --grpc_python_out=. helloworld.proto`
7. Create `server.py` Add the following to the file:

```shell
import grpc
import helloworld_pb2
import helloworld_pb2_grpc
from concurrent import futures

class GreeterServicer(helloworld_pb2_grpc.GreeterServicer):
    def SayHello(self, request, context):
        response = helloworld_pb2.HelloReply(message='Hello, ' + request.name)
        return response
        
    def SayGoodbye(self, request, context):
        response = helloworld_pb2.GoodbyeReply(message='Goodbye, ' + request.name)
        return response

def serve():
    server = grpc.server(futures.ThreadPoolExecutor(max_workers=10))
    helloworld_pb2_grpc.add_GreeterServicer_to_server(GreeterServicer(), server)
    server.add_insecure_port('[::]:50051')
    server.start()
    server.wait_for_termination()

if __name__ == '__main__':
    serve()
```

10. `python server.py`
11. Confirm that the server is running by running `netstat -tulpn | grep 50051`

### Publish a gRPC Proxy with Package-level Routing

{{<tabs name="grpc_policy">}}
{{%tab name="API"%}}

Send a POST request to publish the gRPC proxy.

{{< raw-html>}}<div class="table-responsive">{{</raw-html>}}
{{<bootstrap-table "table">}}
| Method   | Endpoint                                                |
|----------|---------------------------------------------------------|
| `POST`   | `/services/workspaces/<SERVICE_WORKSPACE_NAME>/proxies` |
{{</bootstrap-table>}}
{{< raw-html>}}</div>{{</raw-html>}}

```json
{
    "name": "dev-grpc-hello",
    "version": "v1",
    "proxyConfig": {
        "hostname": "example.com",
        "grpcIngress": {
            "service": "helloworld."
        },
        "backends": [
          {
            "labels": [
                "default"
            ],
            "serviceName": "hello-grpc-service-name",
            "serviceTargets": [
                {
                    "hostname": "grpc-backend.example.com",
                    "labels": [
                        "default"
                    ],
                    "listener": {
                        "enableTLS": false,
                        "port": 50051,
                        "transportProtocol": "GRPC"
                    }
                }
            ]
          }
        ]
    }
}
```

{{< raw-html>}}<div class="table-responsive">{{</raw-html>}}
{{< raw-html>}}</div>{{</raw-html>}}

{{%/tab%}}
{{%tab name="UI"%}}

1. Open a service workspace
2. Click the publish to proxy button
3. Input a `Backend Service` name
4. Input a `Service Target Hostname`
5. Select GRPC for the `Service Target Transport Protocol`
6. Input the `Service Target Port`
7. Input an `API Proxy` name
8. Select a `Gateway Proxy Hostname` from the dropdown
9. Input the `Service name` and `Version`, for this example we will use `helloworld.` and `v1`
10. Click the `Publish` button 

You should now have a published gRPC proxy with a Lifecycle Status of success.

{{%/tab%}}
{{</tabs>}}

#### Service-Level Routing

To configure the proxy to route by service:
1. Open the proxy and click the `Ingress` button.
2. Input the `helloWorld.Greeter` into the `Service Name` field
3. Click the `Save and Publish` button


#### Advanced Routes with a gRPC Method

To configure the proxy with an advanced route 
1. Open the proxy and click the `Ingress` button.
2. Click the add route button and input the `GRPC Method`, for example: `SayGoodbye`
3. Click the `Save and Publish` button
4. // Add in verification step


#### Service-Level Routing using Labels

If you have multiple backend servers and wish to route to a specific backend server you can use labels.

1. Open the proxy and click the `Backend` button.
2. Input a `Service Name` and `Service Version`
3. Input a label for the backend service `custom2`
4. Input a `Service Target Hostname`
5. Click the Add button
6. Click the `Save and Publish` button
7. // Add in verification step



