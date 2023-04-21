---
title: "Publish a gRPC Proxy (preview)"
# Description
# Add a short description (150 chars) for the doc. Include keywords for SEO. 
# The description text appears in search results and at the top of the doc.
description: "Learn how to use NGINX Management Suite API Connectivity Manager to publish a gRPC Proxy and manage traffic to gRPC services."
# Assign weights in increments of 100
weight: 300
toc: true
categories: ["API Connectivity Manager", "API Proxy", "gRPC"]
doctypes: ["task", "beta"]
tags: [ "docs" ]
# Create a new entry in the Jira DOCS Catalog and add the ticket ID (DOCS-<number>) below
docs: "DOCS-997"
---

{{< custom-styles >}}

{{< shortversions "1.2.0" "latest" "acmvers" >}}

## Overview

gRPC has emerged as an alternative approach to building distributed applications, particularly microservice applications. API Connectivity Manager (ACM) supports publishing gRPC services. 

### Preview Release

{{< warning >}}
This is a preview release of gRPC functionality in API Connectivity Manager. This preview has limited capabilities and support and is not recommended for production environments.

The gRPC functionality may change in a later software release without notice or backward compatibility.
{{< /warning >}}

#### Capabilities

With this release, you can publish gRPC proxies and route gRPC traffic to support the following use cases:

- Simple RPC (single request‑response)
- Response‑streaming RPC
- Request‑streaming RPC
- Bidirectional‑streaming RPC
- Route to all services in a gRPC service package
- Route to a single gRPC service
- Route to individual gRPC methods
- Route to multiple gRPC services
- Respond to errors with custom gRPC error response format policy

#### Limitations

The preview release comes with a few limitations:

- API support only for creating and publishing gRPC proxies. There is no web interface (GUI) support for the gRPC workflow.
- With the preview release, gRPC proxies must be managed in a separate environment with a dedicated proxy cluster. Environments cannot be shared to host HTTP and gRPC proxies.
- gRPC environment supports only `Error Response Format policy`. Other policies are not supported.
- Proxy policies are not supported. Although some auth policies may work, they are not supported. Return codes may not be as expected for gRPC.

---

## Before You Begin

To complete the steps in this guide, you need the following:

- API Connectivity Manager is installed, licensed, and running.
- The gRPC service you want to proxy to is up and running. Network communication is established between the proxy cluster and the backend gRPC service.

Before proceeding with this guide, you should familiarize yourself with the [API Overview]({{< relref "/acm/about/api-overview" >}}) section of this series.

To demonstrate the gRPC capabilities, this guide uses a simple test environment that represents the key components of a gRPC proxy with a simple [helloworld](https://grpc.io/docs/languages/go/quickstart/) gRPC service.

- Ensure gRPC service is up and available. 
- Validate the network is established between the backend service and the API gateway.

---

## High-level Workflow

The high-level workflow for an end-to-end setup :

- Within an infra workspace, create an environment with a hostname and the transport protocol set to `GRPC`. 
- Use the onboarding command returned as part of environment creation to onboard one or more instances into a cluster. 
- Upon successfully creating the environment and onboarding a proxy cluster into that environment, the environment is ready to host proxies.
- Within the service workspace, create an API proxy by providing routing instructions and publish the proxy.

### Add an Infrastructure Workspace

First, you'll need to create an Infrastructure Workspace. This logical grouping allows for separation between business units or teams.

{{< raw-html>}}<div class="table-responsive">{{</raw-html>}}
{{<bootstrap-table "table">}}
| Method | Endpoint                     |
|--------|------------------------------|
| POST   | `/infrastructure/workspaces` |
{{</bootstrap-table>}}
{{< raw-html>}}</div>{{</raw-html>}}

```json
{
    "name": "{{infraWorkspaceName}}",
    "metadata": {
        "description": "Finance"
    },
    "contactDetails": {
        "adminEmail": "admin@example.com",
        "adminName": "I.M. Administrator",
        "adminPhone": "086 555 1234"
    }
}
```

### Add an Environment

Next, create an Environment and set the transport protocol to `GRPC`.

#### gRPC

{{< raw-html>}}<div class="table-responsive">{{</raw-html>}}
{{<bootstrap-table "table">}}
| Method | Endpoint                                                         |
|--------|------------------------------------------------------------------|
| POST   | `/infrastructure/workspaces/{{infraWorkspaceName}}/environments` |
{{</bootstrap-table>}}
{{< raw-html>}}</div>{{</raw-html>}}

```json
{
    "name": "test",
    "type": "NON-PROD",
    "functions": [
        "API-GATEWAY"
    ],
    "proxies": [
        {
            "proxyClusterName": "apigw-cluster",
            "hostnames": [
                "example.com"
            ],
            "runtime": "GATEWAY-PROXY",
            "listeners": [
                {
                    "ipv6": false,
                    "isTLSEnabled": false,
                    "port": 80,
                    "transportProtocol": "GRPC"
                }
            ]
        }
    ]
}
```

### Onboard NGINX Plus Instances into the Cluster

Use a dedicated API Gateway cluster for gRPC.

Take the steps in this section to install the NGINX Agent on the data plane instances to onboard them into the proxy cluster you created in the [previous step](#add-an-environment).

To do so, you need to interact directly with the NGINX Plus data plane hosts.

- SSH access to the hosts and `sudo` permissions are required.
- You can add up to three NGINX Plus data plane instances to the cluster.

#### Install NGINX Agent on the Data Plane Hosts {#onboard-nginx-plus}

1. Open an SSH connection to each NGINX Plus data plane host you want to add to the API Gateway cluster and log in.
2. Run the onboarding command as `root` using cURL to download, install, configure, and start the NGINX Agent package. 

   - Replace `{{nms-fqdn}}` in the example command with the FQDN or IP address of your ACM management plane host.
   - Make sure `-g {{clusterName}}` uses the name of your API Gateway cluster.

    ```bash
    curl --insecure https://{{nms-fqdn}}/install/nginx-agent > install.sh && \
    sudo sh install.sh -g {{clusterName}} && sudo systemctl start nginx-agent
    ```

### Verify Instances are Registered with the Cluster

1. Send a GET request to the endpoint below to verify that the instances were added to the cluster.

{{< raw-html>}}<div class="table-responsive">{{</raw-html>}}
{{<bootstrap-table "table">}}
| Method | Endpoint                                                                                                                |
|--------|-------------------------------------------------------------------------------------------------------------------------|
| GET    | `/infrastructure/workspaces/{{infraWorkspaceName}}/environments/{{environmentName}}?includes=instances&includes=status` |
{{</bootstrap-table>}}
{{< raw-html>}}</div>{{</raw-html>}}

### Add a Services Workspace

Now that the environment is created and proxy clusters are registered, we can publish a gRPC service.

First, create a Services Workspace. This is a team space where you can manage the service lifecycle.

{{< raw-html>}}<div class="table-responsive">{{</raw-html>}}
{{<bootstrap-table "table">}}
| Method | Endpoint               |
|--------|------------------------|
| POST   | `/services/workspaces` |
{{</bootstrap-table>}}
{{< raw-html>}}</div>{{</raw-html>}}

```json
{
    "name": "{{proxyWorkspaceName}}",
    "metadata": {
        "description": "Finance"
    },
    "contactDetails": {
        "adminEmail": "admin@example.com",
        "adminName": "Workspace Admin",
        "adminPhone": "086 555 1234"
    }
}
```

### Publish a gRPC Proxy

Next, add an API Proxy, and specify the `grpcIngress` and the backend gRPC service target.

`grpcIngress` can route to a single gRPC service or to individual gRPC methods. In this sample, the proxy is configured to route all methods of the `Greeter` service in the helloworld package.

1. POST to `proxies` endpoint with a payload consisting of `grpcIngress` and routing instructions.

{{< raw-html>}}<div class="table-responsive">{{</raw-html>}}
{{<bootstrap-table "table">}}
| Method | Endpoint                                              |
|--------|-------------------------------------------------------|
| POST   | `/services/workspaces/{{proxyworkspacename}}/proxies` |
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

---

## Precise Routing with gRPC

The gRPC proxy supports simple and complex routing rules with the preview release. The proxy can be configured to:

- Route by Package
- Route by Service
- Route by Method

### Example: Package-level Routing

#### Create an API Proxy with gRPC Ingress and Route by Package

In this example, the proxy routes requests to all of the services and methods defined in the `routeguide` package. 

{{< raw-html>}}<div class="table-responsive">{{</raw-html>}}
{{<bootstrap-table "table">}}
| Method | Endpoint |
|-------------|----------|
| POST| `/services/workspaces/{{proxyworkspacename}}/proxies`| 
{{</bootstrap-table>}}
{{< raw-html>}}</div>{{</raw-html>}}

```json
{
    "name": "proxy",
    "version": "v1",
    "proxyConfig": {
        "hostname": "example.com",
        "grpcIngress": {
            "service": "routeguide."
        },
        "backends": [
            {
                "label": {
                    "targetName": "default"
                },
                "serviceName": "default-grpc-service",
                "serviceTargets": [
                    {
                        "hostname": "backend.example.com",
                        "labels": [
                            "default"
                        ],
                        "listener": {
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

### Example: Service-level Routing

#### Create an API Proxy with gRPC Ingress and Route by Service

In this example, the proxy routes only the `RouteGuide` service from the `routeguide` package. All methods defined in the `RouteGuide` service are routed to the default backend.

{{< raw-html>}}<div class="table-responsive">{{</raw-html>}}
{{<bootstrap-table "table">}}
| Method | Endpoint |
|-------------|----------|
| POST| `/services/workspaces/{{proxyworkspacename}}/proxies`| 
{{</bootstrap-table>}}
{{< raw-html>}}</div>{{</raw-html>}}

```json
    "name": "proxy",
    "version": "v1",
    "proxyConfig": {
        "hostname": "example.com",
        "grpcIngress": {
            "service": "routeguide.RouteGuide"
        },
        "backends": [
            {
                "label": {
                    "targetName": "default"
                },
                "serviceName": "default-grpc-service",
                "serviceTargets": [
                    {
                        "hostname": "backend.example.com",
                        "labels": [
                            "default"
                        ],
                        "listener": {
                            "port": 50051,
                            "transportProtocol": "GRPC"
                        }
                    }
                ]
            }
        ]
    }
```

### Example: Service-level Routing (advanced)

#### Create an API Proxy with gRPC Ingress and route by Method

This is an advanced routing example. Here, the proxy can be configured to route precisely to a gRPC method and reject everything else.

{{< raw-html>}}<div class="table-responsive">{{</raw-html>}}
{{<bootstrap-table "table">}}
| Method | Endpoint |
|-------------|----------|
| POST| `/services/workspaces/{{proxyworkspacename}}/proxies`| 
{{</bootstrap-table>}}
{{< raw-html>}}</div>{{</raw-html>}}

```json
    "name": "proxy",
    "version": "v1",
    "proxyConfig": {
        "hostname": "example.com",
        "grpcIngress": {
            "service": "routeguide.RouteGuide",
            "routes": [
                {
                    "method": "GetFeature",
                    "targetBackendServiceLabel": "custom1"
                },
                {
                    "method": "ListFeatures",
                    "targetBackendServiceLabel": "custom2"
                }
            ]
        },
        "backends": [
            {
                "label": {
                    "targetName": "custom1"
                },
                "serviceName": "custom-grpc-service",
                "serviceTargets": [
                    {
                        "hostname": "custom1.backend.com",
                        "listener": {
                            "port": 50051,
                            "transportProtocol": "GRPC"
                        }
                    }
                ]
            },
            {
                "label": {
                    "targetName": "custom2"
                },
                "serviceName": "custom-grpc-service-2",
                "serviceTargets": [
                    {
                        "hostname": "custom2.backend.com",
                        "listener": {
                            "port": 50051,
                            "transportProtocol": "GRPC"
                        }
                    }
                ]
            }
        ]
    }

```


