---
description: Learn how to use F5 NGINX Management Suite API Connectivity Manager to
  publish a gRPC Proxy and manage traffic to gRPC services.
docs: DOCS-997
title: Publish a gRPC API Proxy
toc: true
weight: 300
type:
- how-to
---

{{< shortversions "1.2.0" "latest" "acmvers" >}}

## Overview

gRPC has emerged as an alternative approach to building distributed applications, particularly microservice applications. API Connectivity Manager supports publishing gRPC services.
The following document describes how to publish a gRPC API proxy using the API Connectivity Manager API or UI. Additionally, this guide outlines the process of setting up a gRPC Echo Server to validate the functionality of the published proxy.


## Publish a gRPC API Proxy with Package-level Routing

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




{{%/tab%}}
{{%tab name="UI"%}}

1. Open a service workspace.
1. Select **Publish to proxy**.
1. Type a **Backend Service** name.
1. Enter a **Service Target Hostname**.
1. Select GRPC in the **Service Target Transport Protocol** menu.
1. Enter the **Service Target Port**.
1. Enter an **API Proxy** name.
1. Select a **Gateway Proxy Hostname** in the menu.
1. Enter the **Service name** and **Version**; for this example, we use "helloworld" and "v1".
1. Select **Publish**.

You should now have a published gRPC API proxy with a Lifecycle Status of success.

{{%/tab%}}
{{</tabs>}}

## Publish a gRPC API Proxy with Service-Level Routing

{{<tabs name="grpc_policy_service">}}
{{%tab name="API"%}}

Send a POST request to publish the gRPC proxy.


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




{{%/tab%}}
{{%tab name="UI"%}}

To configure the proxy to route by service:

1. Open the proxy and select **Ingress**.
1. Type "helloWorld.Greeter" in the **Service Name** field.
1. Select **Save and Publish**.

{{%/tab%}}
{{</tabs>}}


## Publish a gRPC API Proxy with Advanced Routes with a gRPC Method

{{<tabs name="grpc_policy_routes">}}
{{%tab name="API"%}}

Send a POST request to publish the gRPC proxy.


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




{{%/tab%}}
{{%tab name="UI"%}}


To configure the proxy with an advanced route

1. Open the proxy and select the **Ingress**.
1. Select **Add route** and enter the **GRPC Method**; for example, "SayGoodbye".
1. Select **Save and Publish**.
1. Proceed to [Set Up gRPC Echo Server and Test gRPC API Proxy](#setup-grpc-echo-server-optional) for the next steps.

{{%/tab%}}
{{</tabs>}}


## Service-Level Routing using Labels
{{<tabs name="grpc_policy_labels">}}
{{%tab name="API"%}}

Send a POST request to publish the gRPC proxy.


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





{{%/tab%}}
{{%tab name="UI"%}}

If you have multiple backend servers and want to route to a specific backend server, you can use labels.

1. Open the proxy and select **Backend**.
1. Enter a **Service Name** and **Service Version**.
1. Add a label for the backend service, "custom2".
1. Type the **Service Target Hostname**.
1. Select **Add**.
1. Select **Save and Publish**.
1. [Setup gRPC Echo Server and Test gRPC API Proxy](#setup-grpc-echo-server-optional).

{{%/tab%}}
{{</tabs>}}

## Backends

Backends specify where your API should send queries, such as to your backend server.

You can add, edit, or delete backends.

You can also set [DNS](https://en.wikipedia.org/wiki/Domain_Name_System) resolvers and [TLS](https://en.wikipedia.org/wiki/Transport_Layer_Security) on the backend.

## Policies

This section ensures you can set policies at the individual API level.

For more information, refer to the [Manage Policies]({{< relref "/nms/acm/how-to/policies/manage-policies.md" >}}) documentation.

## Update a Published API Proxy

1. On the sidebar, select **Services**. Then on the Services Workspaces page, select the workspace containing the API proxy you want to edit.
2. Select **Edit Proxy** from the **Actions** menu of the Proxy you want to delete.
3. Edit as needed.
4. Select **Save and Publish**.

## Delete a Published API Proxy

1. On the sidebar, select **Services**. Then on the Services Workspaces page, select the name of the workspace containing the API proxy you want to delete.
2. Select **Delete Proxy** from the **Actions** menu of the Proxy you want to delete.

## Set Up gRPC Echo Server (Optional) {#setup-grpc-echo-server-optional}

This section explains how to set up a gRPC echo server to verify that the gRPC API works as expected.

From a command line terminal:

1. Create a virtual environment and install the required packages:

   ```shell
   virtualenv echo-servers
   source echo-servers/bin/activate
   pip install grpcio protobuf grpcio-tools
   ```

1. Create a file named `helloworld.proto` and add the following content:

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

1. Run the following command to generate the python code: `python -m grpc_tools.protoc -I. --python_out=. --grpc_python_out=. helloworld.proto`
1. Create `server.py` Add the following to the file:

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

1. Run `python server.py`.
1. To confirm the server is running, run the command `netstat -tulpn | grep 50051`.
1. For step-by-step instructions on how to set up gRPC testing using Postman, refer to [Testing gRPC APIs with Postman](https://blog.postman.com/testing-grpc-apis-with-postman/).  This guide will help you test and validate your gRPC APIs effectively using Postman.
