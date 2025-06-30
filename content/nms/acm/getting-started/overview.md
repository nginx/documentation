---
description: Learn how to get up and running with F5 NGINX Management Suite API Connectivity
  Manager.
nd-docs: DOCS-939
title: Get Started
toc: true
weight: 10
---

<style>
    h2 {
        margin-top: 30px;
        margin-bottom: 10px;
    }
    h3 {
        margin-top: 30px;
        margin-bottom: 10px;
        font-weight: 300;
        font-size: 1.75em;
    }
    h4 {
        margin-top: 30px;
        font-size: 20px;
    }
    hr {
        margin-top: 40px;
        margin-bottom: 20px;
    }
    td hr {
        margin-top: 10px;
        margin-bottom: 10px;
    }
</style>

{{< shortversions "1.1.0" "latest" "acmvers" >}}

## Objectives

By completing the guides in this Quick Start series, you can easily get up and running with API Connectivity Manager.

This series covers the following topics:

1. Setting up an environment with [API Gateway]({{< relref "./add-api-gateway" >}}) & [Developer Portal]({{< ref "add-devportal" >}}) clusters.
2. Onboarding F5 NGINX Plus instances onto the clusters.
3. [Publishing an API proxy]({{< ref "publish-api-proxy" >}}) with or without an OpenAPI spec.

---

## Requirements

To complete the instructions in this series, you must meet the following requirements:

1. [Install API Connectivity Manager and Developer Portal]({{< ref "/nim/deploy/_index.md" >}}) on [separate hosts]({{< ref "/nim/fundamentals/tech-specs.md" >}}).
2. [Install a supported version of NGINX Plus]({{< ref "/nim/fundamentals/tech-specs.md" >}}) on one or more hosts to serve as the API Gateway.
3. [Install the `njs` module](https://docs.nginx.com/nginx/admin-guide/dynamic-modules/nginscript/) on your NGINX data plane and Dev Portal hosts.
4. You have SSH access and `sudo` permissions for the NGINX data plane host(s).
5. You have an API Connectivity Manager user account with permission to READ, CREATE, UPDATE, and DELETE on the following API Connectivity Manager features:

    - Infrastructure
    - Services

---

## How to Access the REST API

{{< include "acm/how-to/access-acm-api" >}}

For example:

```shell
curl --location --request POST 'https://{{nms-fqdn}}/api/acm/v1/services/workspaces/{{workspaceName}}' \
--header 'Accept: application/json' \
--header 'Content-Type: application/json' \
--header 'Authorization: Bearer <access token>' \
--data-raw ''
```

---

## Variables

The examples provided in these guides use a set of common variables.
You should replace these variables -- or define a set of values for them in your API client -- with information relevant to your environment before trying to use them.
The variables used in the examples are described in the table below.


{{< bootstrap-table "table table-hover table-bordered" >}}
|Variable | Definition |
|---|-------|
| `nms-fqdn`| The fully-qualified domain name (FQDN) or IP address of the host running NGINX Management Suite.<br>This is also referred to as the "management plane" host. |
| `backendIp` | The IP address or hostname of a backend server running an API service. |
| `nginxInstance` | The IP address or hostname of an NGINX data plane instance. |
| `devPortalIp` | The IP address or hostname of the instance hosting the Developer Portal. |
| `username` | Your account username. |
| `password` | Your account password. |
| `instanceGroupName` | The name of the API Gateway. This name is recorded as an Instance Group name by the NGINX Agent. |
| `infraWorkspaceName` | The name of the Infrastructure Workspace that you want to work in. |
| `proxyWorkspaceName` | The name of the Service Workspace that you want to work in. |
| `proxyName` | The name of the Proxy that you want to create, read, update, or delete. |
| `environmentName` | The name of the Environment that you want to work in. |
| `environmentHostname` | The hostname of the API Gateway. |
| `devPortalName` | The resource name of the Developer Portal Proxy. |
| `portalDocsName` | The resource name of the API Docs. |
| `portalInstanceGroupName` | The resource name of the Developer Portal. |
| `portalClusterHostname` | The hostname for the Developer Portal. |
| `clusterName` | The proxy cluster name for the Developer Portal or API Gateway. |

{{< /bootstrap-table >}}

