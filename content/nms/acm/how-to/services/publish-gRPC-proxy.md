---
title: "Publish a gRPC API Proxy"
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


### Publish a gRPC API Proxy with Package-level Routing

{{<tabs name="grpc_policy_package">}}
{{%tab name="API"%}}

Send a POST request to publish the gRPC API proxy.

{{<bootstrap-table "table">}}
| Method   | Endpoint                                                |
|----------|---------------------------------------------------------|
| `POST`   | `/services/workspaces/<SERVICE_WORKSPACE_NAME>/proxies` |
{{</bootstrap-table>}}

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
            "serviceName": "hello-grpc-service-name",
            "serviceTargets": [
                {
                    "hostname": "grpc-backend.example.com",
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

You should now have a published gRPC API proxy with a Lifecycle Status of success.

{{%/tab%}}
{{</tabs>}}

### Publish a gRPC API Proxy with Service-Level Routing

{{<tabs name="grpc_policy_service">}}
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
            "service": "helloworld.Greeter"
        },
        "backends": [
          {
            "serviceName": "hello-grpc-service-name",
            "serviceTargets": [
                {
                    "hostname": "grpc-backend.example.com",
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

To configure the proxy to route by service:
1. Open the proxy and click the `Ingress` button.
2. Input the `helloWorld.Greeter` into the `Service Name` field
3. Click the `Save and Publish` button

{{%/tab%}}
{{</tabs>}}


### Publish a gRPC API Proxy with Advanced Routes with a gRPC Method

{{<tabs name="grpc_policy_routes">}}
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
            "service": "helloworld.Greeter",
            "routes": [
                {
                  "method": "SayGoodbye",
                  "targetBackendServiceLabel": "default"
                },
                {
                  "method": "SayHello",
                  "targetBackendServiceLabel": "default"
                }
            ]
        },
        "backends": [
          {
            "serviceName": "hello-grpc-service-name",
            "serviceTargets": [
                {
                    "hostname": "grpc-backend.example.com",
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


To configure the proxy with an advanced route 
1. Open the proxy and click the `Ingress` button.
2. Click the add route button and input the `GRPC Method`, for example: `SayGoodbye`
3. Click the `Save and Publish` button
4. [Setup gRPC Echo Server and Test gRPC API Proxy](#setup-grpc-echo-server-optional)

{{%/tab%}}
{{</tabs>}}


### Service-Level Routing using Labels
{{<tabs name="grpc_policy_labels">}}
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
            "service": "helloworld.Greeter",
            "routes": [
                {
                  "method": "SayGoodbye",
                  "targetBackendServiceLabel": "custom"
                },
                {
                  "method": "SayHello",
                  "targetBackendServiceLabel": "default"
                }
            ]
        },
        "backends": [
            {"label": {
              "targetName": "default"
            },
            "serviceName": "hello-grpc-service-name",
            "serviceTargets": [
                {
                    "hostname": "grpc-backend.example.com.1",
                    "listener": {
                        "enableTLS": false,
                        "port": 50051,
                        "transportProtocol": "GRPC"
                    }
                }
            ]
          },        
          {
             "label": {
              "targetName": "custom"
            },
            "serviceName": "hello-grpc-service-name",
            "serviceTargets": [
                {
                    "hostname": "grpc-backend.example.com.2",
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

If you have multiple backend servers and wish to route to a specific backend server you can use labels.

1. Open the proxy and click the `Backend` button.
2. Input a `Service Name` and `Service Version`
3. Input a label for the backend service `custom2`
4. Input a `Service Target Hostname`
5. Click the Add button
6. Click the `Save and Publish` button
7. [Setup gRPC Echo Server and Test gRPC API Proxy](#setup-grpc-echo-server-optional)

{{%/tab%}}
{{</tabs>}}

## Backends

Backends tell your API where to resolve the queries to, for example your backend server.

You can add, edit, or delete Backends.

You can also set [DNS](https://en.wikipedia.org/wiki/Domain_Name_System) resolvers and [TLS](https://en.wikipedia.org/wiki/Transport_Layer_Security) on the backend.

## Policies

This section ensures you can set policies at the individual API level.

Check the [Manage Policies]({{< relref "/nms/acm/how-to/policies/manage-policies.md" >}}) documentation for more information.

## Update a Published API Proxy

1. On the sidebar, select **Services**. Then on the Services Workspaces page, select the workspace containing the API proxy you want to edit.
2. Select **Edit Proxy** from the **Actions** menu of the Proxy you want to delete.
3. Edit as needed.
4. Select **Save and Publish**.

## Delete a Published API Proxy

1. On the sidebar, select **Services**. Then on the Services Workspaces page, select the name of the workspace containing the API proxy you want to delete.
2. Select **Delete Proxy** from the **Actions** menu of the Proxy you want to delete.

## Setup gRPC Echo Server (Optional) {#setup-grpc-echo-server-optional}
This section details how to setup a gRPC echo server which can be used to confirm that the gRPC API is working as expected.

From a command line terminal:
1. Create a virtual environment and install the required packages:

```shell
virtualenv echo-servers
source echo-servers/bin/activate
pip install grpcio protobuf grpcio-tools
```
2. Create a file called `helloworld.proto` and add the following:

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
12. For step-by-step instructions on setting up gRPC testing using Postman, please refer to the following <a href="https://blog.postman.com/testing-grpc-apis-with-postman/">Testing gRPC APIs with Postman</a>  This guide will walk you through the process, ensuring you can effectively test and validate your gRPC APIs using Postman.
