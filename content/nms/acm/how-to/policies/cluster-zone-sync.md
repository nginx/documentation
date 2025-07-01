---
description: Learn how to configure the Cluster Zone Sync policy to enable runtime
  state sharing between the instances belonging to a proxy cluster.
nd-docs: DOCS-1159
title: Cluster Zone Sync
toc: true
weight: 499
type:
- concept
---

## Overview

{{< include "acm/how-to/policies-proxy-cluster-intro" >}}

---

## About the Policy

Use the *Cluster Zone Sync* policy to enable runtime state sharing between the instances belonging to a proxy cluster. Options configured through this policy affect other policies such as rate limit and OIDC. This policy is applied to all the instances in a proxy cluster. If the proxy cluster is shared between environments, any changes made to this policy will affect all the other environments.

### Intended Audience

{{< include "acm/how-to/policies/infra-admin-persona.md">}}

---

## Workflow for Applying Policy

To apply the policy or make changes to it, here's what you need to do:

- Create an environment or edit an existing one.
- Check the cluster config settings for the environment to see if the policy has been applied.
- Edit the policy to make changes for each cluster. Save and publish the changes.

{{< note >}}
We strongly recommend securing your Zone Sync environment by enabling TLS for your listeners and Zone Sync TLS verification for the policy. To do this, you'll need to provide server certificates, as well as Zone Sync certificates and CA certs.

When adding a new instance to a cluster with the Zone Sync policy applied, make sure the instance is resolvable by DNS if a DNS server is used, or that the Zone Sync Server list is updated to include the instance if the list is provided manually.

Similarly, when removing an instance from a cluster with the Zone Sync policy applied, be sure to do the necessary clean-up in the DNS resolver or the Zone Sync Server list.
{{< /note >}}

---

## Policy Settings

The following table lists the configurable settings and their default values for the policy.


{{< bootstrap-table "table table-striped table-bordered" >}}

| Field        | Datatype | Possible Values     | Description                                        | Required | Default               |
|--------------|----------|---------------------|----------------------------------------------------|----------|-----------------------|
| `tcpServer.listeners[].transportProtocol`   | string  | ["TCP"]  | Stream listener to configure protocol for zone sync stream.            | No      |  "TCP" |
| `tcpServer.listeners[].port`   | integer  | In range `1-65535` | Stream listener to configure port for zone sync stream.                           | Yes      |   |
| `tcpServer.listeners[].enableTLS`   | boolean  |  fase/true | Stream listener to enable TLS for zone sync stream.                          | No      | false  |
| `tcpServer.listeners[].ipv6`   | boolean  | false/true   | Stream listener to enable ipv6 for zone sync stream.                         | No     | false  |
| `tcpServer.hostnames`   | array  |   | Configure hostnames                       | No      | []      |
| `tcpServer.tlsCipher`   | string  |    | Specifies the enabled ciphers. The ciphers are specified in the format understood by the OpenSSL library                             | No      | ECDH+AESGCM:ECDH+AES256:ECDH+AES128:DH+3DES:!ADH:!AECDH:!MD5       |
| `tcpServer.tlsSessionCache.enable`   | string  | [ "on", "off", "none" ]  | Specifies session parameters to avoid SSL handshakes for parallel and subsequent connections.                            | No      | "on"    |
| `tcpServer.tlsSessionCache.type`   | string  | [ "shared", "builtin" ]   | Specifies session parameters to avoid SSL handshakes for parallel and subsequent connections.                            | No      | "shared"    |
| `tcpServer.tlsSessionCache.size`   | string  | ^([0-9]+)(([K\|M\|G]){1})$  |  Maximum size of the Cache.  Valid units are: K, M, G for kilobytes, megabytes, and gigabytes, respectively.                            | No      | "10M"      |
| `tcpServer.tlsProtocols`   | array  | ["TLSv1.1", "TLSv1.2", "TLSv1.3"]   | Enables the specified protocols.                             | No      |  [ "TLSv1.2" ]      |
| `tcpServer.tlsSessionTimeout`   | string  | ^([0-9]+)(([d\|h\|m\|s]){1})$  | Specifies cache timeout.  Valid units are: s, m, h and d for seconds, minutes, hours, and days respectively.                            | No      | "5m"       |
| `zoneSyncServers[].hostname`   | array  |           | Defines the address of a cluster node. The address can be specified as a domain name or IP address.  A domain name that resolves to several IP addresses defines multiple nodes at once.    | Yes      |                       |
| `zoneSyncServers[].port`   | array  |           | Defines the address of a cluster node. The address can be specified as a domain name or IP address.  A domain name that resolves to several IP addresses defines multiple nodes at once.    | Yes      |                       |
| `enableZoneSyncTLS`   | boolean  | false             |             Enables the TLS protocol for connections to another cluster server. When this is enabled certificates need to be provided in the data section of the policy.         | No      |          System assigned           |
| `enableZoneSyncCertVerify`   | boolean  | false              | Enables the TLS verification for connections to another cluster server. When this is enabled certificates need to be provided in the data section of the policy.         | No      |         System assigned            |
| `zoneSyncCertChainVerifyDepth`   | integer  | 1             | Sets the verification depth for another cluster server certificates chain.                          | No     |    System assigned                   |
| `zoneSyncEnableSNI`   | boolean  |      false         | Enables or disables passing of the server name through TLS Server Name Indication (SNI) when establishing a connection with another cluster server.     | No     |          System assigned             |
| `zoneSyncTLSName`   | string  | In range `1–110`               | Allows overriding the server name used to verify the certificate of a cluster server and to be passed through SNI when establishing a connection with the cluster server.                          | No    |                       |
| `zoneSyncBuffers.number`   | integer  | 1–128             | Configure size and umber of per-zone buffers used for pushing zone contents. A single buffer must be large enough to hold any entry of each zone being synchronized.  | No     |      8                 |
| `zoneSyncBuffers.size`   | string  | ^[0-9]+[K\|M\|G]{1}$           | Configure size and umber of per-zone buffers used for pushing zone contents. A single buffer must be large enough to hold any entry of each zone being synchronized.  | No     |             "8k"          |
| `zoneSyncConnectionRetryInterval`   | string  | ^[0-9]+[h\|m\|s]{1}$             | Defines an interval between connection attempts to another cluster node.  | No     |         "1s"              |
| `zoneSyncConnectionTimeout`   | string  | ^[0-9]+[h\|m\|s]{1}$              | Defines a timeout for establishing a connection with another cluster node.  | No     |                 "5s"      |
| `zoneSyncInterval`   | string  | ^[0-9]+[h\|m\|s]{1}$               | Defines an interval for polling updates in a shared memory zone.  | No     |        "1s"               |
| `zoneSyncTimeout`   | string  | ^[0-9]+[h\|m\|s]{1}$              | Sets the timeout between two successive read or write operations on connection to another cluster node.  | No     |      "1s"                 |

{{< /bootstrap-table >}}


---

## Adding Cluster Zone Sync Policy

{{<tabs name="policy-implementation">}}

{{%tab name="API"%}}

{{<see-also>}}{{< include "acm/how-to/access-acm-api.md" >}}{{</see-also>}}

To create an Cluster Zone Sync policy using the REST API, send an HTTP `PUT` request to the Add-Endpoint-Name-Here endpoint.


{{< bootstrap-table "table table-striped table-bordered" >}}

| Method | Endpoint            |
|--------|---------------------|
| `PUT` | `/infrastructure/workspaces/{infraWorkspaceName}/proxy-clusters/{clusterName}` |

{{</bootstrap-table>}}


<details open>
<summary>JSON request - Cluster Zone Sync with minimum configuration</summary>

``` json
{
  "cluster-zone-sync": [
    {
      "action": {
        "tcpServer": {
          "listeners": [
            {
              "port": 12345
            }
          ]
        },
        "zoneSyncServers": [
          {
            "name": "nginx-cluster-instance-1.com",
            "port": 12345
          },
          {
            "name": "nginx-cluster-instance-2.com",
            "port": 12345
          }
        ]
      }
    }
  ]
}
```

</details>

<details open>
<summary>JSON request - Cluster Zone Sync with DNS Resolver</summary>

``` json
{
  "cluster-zone-sync": [
    {
      "action": {
        "tcpServer": {
          "listeners": [
            {
              "port": 12345
            }
          ],
        },
        "resolver": {
          "enableIPv6": false,
          "valid": "30s",
          "timeout": "5s",
          "servers": [
            {
              "hostname": "192.0.2.0"
            }
          ]
        },
        "zoneSyncServers": [
          {
            "name": "nginx-cluster.com",
            "port": 12345
          }
        ]
      }
    }
  ]
}
```

</details>

<details open>
<summary>JSON request - Cluster Zone Sync with DNS Resolver and TCP Server TLS enabled</summary>

``` json
{
  "cluster-zone-sync": [
    {
      "action": {
        "tcpServer": {
          "listeners": [
            {
              "port": 12345,
              "tlsEnabled": true
            }
          ],
        },
        "resolver": {
          "enableIPv6": false,
          "valid": "30s",
          "timeout": "5s",
          "servers": [
            {
              "hostname": "192.0.2.0"
            }
          ]
        },
        "zoneSyncServers": [
          {
            "name": "nginx-cluster.com",
            "port": 12345
          }
        ]
      },
      "data": {
        "serverCerts": [
          {
            "key": "<server-key>",
            "cert": "<server-cert>"
          }
        ]
      }
    }
  ]
}

```

</details>

<details open>
<summary>JSON request - Cluster Zone Sync with secure TLS between nodes in a cluster </summary>

``` json
{
  "cluster-zone-sync": [
    {
      "action": {
        "tcpServer": {
          "listeners": [
            {
              "port": 12345,
              "tlsEnabled": true
            }
          ],
        },
        "resolver": {
          "enableIPv6": false,
          "valid": "30s",
          "timeout": "5s",
          "servers": [
            {
              "hostname": "192.0.2.0"
            }
          ]
        },
        "enableZoneSyncTLS": true,
        "zoneSyncServers": [
          {
            "name": "nginx-cluster.com",
            "port": 12345
          }
        ]
      },
      "data": {
        "serverCerts": [
          {
            "key": "<server-key>",
            "cert": "<server-cert>"
          }
        ],
        "zoneSyncCerts": [
          {
            "key": "<server-key>",
            "cert": "<server-cert>"
          }
        ],
        "zoneSyncTrustedCACert": "<ca-cert>"
      }
    }
  ]
}

```

</details>

<details open>
<summary>JSON request - Cluster Zone Sync with all options specified </summary>

``` json
{
  "cluster-zone-sync": [
    {
      "action": {
        "tcpServer": {
          "listeners": [
            {
              "port": 12345,
              "tlsEnabled": true
            }
          ],
          "hostnames": ["10.0.0.9"],
          "tlsProtocols": ["TLSv1.1", "TLSv1.2", "TLSv1.3"],
          "tlsCipher": "ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-CHACHA20-POLY1305:ECDHE-RSA-CHACHA20-POLY1305:DHE-RSA-AES128-GCM-SHA256:DHE-RSA-AES256-GCM-SHA384",
          "tlsSessionCache": {
            "enable": "none"
          },
          "tlsSessionTimeOut": "15m"
        },
        "resolver": {
          "enableIPv6": false,
          "valid": "30s",
          "timeout": "5s",
          "servers": [
            {
              "hostname": "192.0.2.0"
            }
          ]
        },
        "enableZoneSyncTLS": true,
        "enableZoneSyncCertVerify": true,
        "zoneSyncCertChainVerifyDepth": 2,
        "zoneSyncEnableSNI": true,
        "zoneSyncTLSServerName": "custom-sni-host.com",
        "zoneSyncServers": [
          {
            "name": "nginx-cluster.com",
            "port": 12345
          }
        ],
        "syncBuffers": {
          "number": 10,
          "size": "8k"
        },
        "connectionRetryInterval": "8s",
        "connectionTimeout": "10m",
        "timeout": "5s",
        "interval": "1s"
      },
      "data": {
        "serverCerts": [
          {
            "key": "<server-key>",
            "cert": "<server-cert>"
          }
        ],
        "zoneSyncCerts": [
          {
            "key": "<server-key>",
            "cert": "<server-cert>"
          }
        ],
        "zoneSyncTrustedCACert": "<ca-cert>"
      }
    }
  ]
}

```

</details>

{{%/tab%}}

{{%tab name="UI"%}}

To create a Cluster Zone Sync policy using the web interface:

1. In a web browser, go to the FQDN for your F5 NGINX Management Suite host and log in. Then, from the Launchpad menu, select **API Connectivity Manager**.
2. On the left menu, select **Infrastructure**.
3. Choose the workspace that contains your cluster's environment from the list of workspaces.
4. In the **Environments** section, select the environment name for your cluster.
5. In the list of clusters, locate the cluster you want to add the policy to. On the **Actions** menu (represented by an ellipsis, `...`), select **Edit Cluster Config**.
6. On the left menu, select **Cluster Policies**.
7. Locate the **Cluster Zone Sync** policy in the list of policies. On the **Actions** menu (represented by an ellipsis, `...`), select **Add Policy**.
8. On the **Cluster Zone Sync** form, complete the necessary fields:

   - **TLS Server Settings -  Port**: Specify port for zone sync stream server.
   - **Zone Sync Settings - hostname**: Enter the address of a cluster node. The address can be specified as a domain name or IP address. A domain name that resolves to several IP addresses defines multiple nodes at once.
9. Select **Add** to apply the policy to the cluster.
10. Select **Save and Submit** to deploy the configuration.

{{%/tab%}}

{{</tabs>}}

---

## Verify the Policy

Confirm that the policy has been set up and configured correctly by taking these steps:

- Verify OIDC KeyValue Zone Sync is synchronized between instances within a cluster.
- Verify no OIDC session issues are presented when using multiple instances in a cluster.
- Verify applied rate limit for a proxy in a cluster is synchronized between instances within a cluster.

---

## Troubleshooting

For help resolving common issues when setting up and configuring the policy, follow the steps in this section. If you cannot find a solution to your specific issue, reach out to [NGINX Customer Support]({{< ref "/nms/support/contact-support.md" >}}) for assistance.

### Issue 1

When the runtime state is not syncing between the instances in a desired proxy cluster.

Resolution/Workaround:

1. Ensure the tcp listener port of each instance is accessible within the desired proxy cluster.
2. By default the tcp listener port is open for all, but if you've provided tcp hostnames, then ensure the desired hostnames are resolvable.

### Issue 2

If you see errors in the NGINX logs related to TLS when TLS is enabled (`enableZoneSyncTLS` is set to `true`) and zone sync servers are IP addresses, try the following workarounds:

Resolution/Workaround:

1. Ensure that you override the default server name (`zoneSyncTLSName`) used to verify the certificate of the desired cluster server to match the Subject Alternative Name of the cert provided.
2. If you are using DNS for zone sync servers, make sure you use the correct certificate that matches the hostname provided under zone sync server option (`zoneSyncServers[].hostname`).
