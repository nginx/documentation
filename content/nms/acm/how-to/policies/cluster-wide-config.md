---
description: Learn how to configure the Cluster-Wide Config settings to fine tune
  and control proxy cluster's behavior with performance enhancing configurations.
nd-docs: DOCS-1160
title: Cluster-Wide Config
toc: true
weight: 498
type:
- concept
---

## Overview

{{< include "acm/how-to/policies-proxy-cluster-intro" >}}

---

## About the Policy

Use the *Cluster-Wide Config* settings to fine tune the worker connections, [hash table size](https://nginx.org/en/docs/hash.html), and keepalive settings to speed up data processing and improve the performance of the API proxy for large number of connections. When applied, the settings are applicable to all the instances in a proxy cluster. If the proxy cluster is shared between environments, the changes made in any environment will be reflected in all the other environments.

### Intended Audience

{{< include "acm/how-to/policies/infra-admin-persona.md">}}

---

## Workflow for Applying Policy

To apply the policy or make changes to it, here's what you need to do:

- Create an environment or edit an existing one.
- Check the cluster config settings for the environment to see if the policy has been applied.
- Edit the policy to make changes for each cluster. Save and publish the changes.

---

## Policy Settings {#policy-settings}

The following table lists the configurable settings and their default values for the policy.


{{< bootstrap-table "table table-striped table-bordered" >}}

| Field        | Datatype | Possible Values     | Description                                        | Required | Default               |
|--------------|----------|---------------------|----------------------------------------------------|----------|-----------------------|
| `mapHashBucketSize`   | integer  |  example: 256 | Sets the bucket size for the map hash table.                             | No      | 128       |
| `mapHashMaxSize` | integer   |  example: 2048 | Sets the maximum bucket size for the map hash table. | No      | 2048 |
| `serverNamesHashBucket`   | integer  | example: 256              | Sets the bucket size for the server names hash tables                          | No      |   256                    |
| `serverNamesHashMaxSize`   | integer  | example: 1024               | Sets the maximum size of the server names hash tables.                          | No      |    1024                    |
| `workersConfig.connections`   | integer  | In range `256–65536`               | Sets the maximum number of simultaneous connections that can be opened by a worker process.                          | No      |                8192      |
| `workersConfig.maxProcesses`   | string  | `^(auto\|[1-9]\|[1-2][0-9]\|3[0-2])$`    | Defines the number of worker processes.                          | No      |          auto             |
| `workersConfig.maxLimitForOpenFile`   | integer  | In range `512–262144`              | Changes the limit on the maximum number of open files (RLIMIT_NOFILE) for worker processes. Used to increase the limit without restarting the main process.                          | No      |      20000                 |
| `clientConnection.keepaliveTimeout`   | string  | ^([0-9]+)(([h\|m\|s]){1})$         | The first parameter sets a timeout during which a keep-alive client connection will stay open on the server side.                         | No      |       75s                |
| `clientConnection.keepaliveHeaderTimeout`   | string  | ^([0-9]+)(([h\|m\|s]){1})$             | ?                         | No      |                       |
| `clientConnection.keepaliveRequests`   | integer  | In range `50–20000`             | Sets the maximum number of requests that can be served through one keepalive connection.                          | No      |               1000        |
| `clientConnection.keepaliveTime`   | string  | ^([0-9]+)(([h\|m\|s]){1})$             |  Maximum time during which requests can be processed through one keepalive connection.                        | No      |         "1h"              |
| `clientHeaderBuffer.size`   | string  | ([.\d]+)(?:M\|K)             | Sets the maximum size of buffers used for reading a large client request header.                          | No      |          8K             |
| `clientHeaderBuffer.number`   | integer  | In range `1–64`            | Sets the maximum number of buffers used for reading a large client request header.                          | No      |        4               |
| `clientHeaderBuffer.timeout`   | string  | ^[0-9]+[h\|m\|s]{1}$            | Defines a timeout for reading client request header.                          | No      |      "60s"                 |

{{< /bootstrap-table >}}


---

## Updating Cluster-Wide Policy

{{<tabs name="policy-implementation">}}

{{%tab name="API"%}}

{{<see-also>}}{{< include "acm/how-to/access-acm-api.md" >}}{{</see-also>}}

To create an Cluster-Wide Config settings using the REST API, send an HTTP `PUT` request to the Add-Endpoint-Name-Here endpoint.


{{< bootstrap-table "table table-striped table-bordered" >}}

| Method | Endpoint            |
|--------|---------------------|
| `PUT` |  `/infrastructure/workspaces/{infraWorkspaceName}/proxy-clusters/{clusterName}`|

{{</bootstrap-table>}}


<details open>
<summary>JSON request - Cluster-Wide Config with minimum configuration</summary>

``` json
{
    "policies": {
      "cluster-wide-config": [],
    }
}
```

</details>

<details open>
<summary>JSON request - Cluster-Wide Config with all options specified</summary>

``` json
{
  "policies": {
    "cluster-wide-config": [
      {
        "action": {
            "clientConnection": {
                "keepaliveRequests": 1000,
                "keepaliveTime": "1h",
                "keepaliveTimeout": "75s"
            },
            "clientHeaderBuffer": {
                "number": 4,
                "size": "8K",
                "timeout": "60s"
            },
            "mapHashBucketSize": 128,
            "mapHashMaxSize": 2048,
            "serverNamesHashBucket": 256,
            "serverNamesHashMaxSize": 1024,
            "workersConfig": {
                "connections": 8192,
                "maxLimitForOpenFile": 20000,
                "maxProcesses": "auto"
            }
        },
      }
    ],
  }
}
```

</details>

{{%/tab%}}

{{%tab name="UI"%}}

To create a Cluster-Wide Config setting using the web interface:

1. In a web browser, go to the FQDN for your F5 NGINX Management Suite host and log in. Then, from the Launchpad menu, select **API Connectivity Manager**.
2. On the left menu, select **Infrastructure**.
3. Choose the workspace that contains your cluster's environment from the list of workspaces.
4. In the **Environments** section, select the environment name for your cluster.
5. In the list of clusters, locate the cluster you want to add the policy to. On the **Actions** menu (represented by an ellipsis, `...`), select **Edit Cluster Config**.
6. On the left menu, select **Cluster Policies**.
7. In the list of Cluster Policies, the Cluster-Wide Config setting should be enabled by default. To edit the policy, select the ellipsis icon (`...`), then select **Edit Cluster Config**.
8. Customize the policy settings to suit your requirements. Refer to the [Policy Settings](#policy-settings) section for an overview of the available options and their possible configurations.
9. Select **Save** to save the changes.
10. Select **Save and Submit** to publish the policy changes to the environment.

{{%/tab%}}

{{</tabs>}}

---

## Verify the Policy

Confirm that the policy has been set up and configured correctly by taking these steps:

- Verify the NGINX configuration was applied by this policy.


