---
title: "Migration Guide"
date: 2021-12-21T12:00:00-07:00
draft: false
description: "Follow the instructions in this guide to migrate from Instance Manager v1 to v2."
# Assign weights in increments of 100
weight: 1
toc: true
tags: [ "beta", "docs" ]
# Taxonomies
# These are pre-populated with all available terms for your convenience.
# Remove all terms that do not apply.
categories: ["installation"]
doctypes: ["task"]
docs: "DOCS-801"
aliases:
- /nginx-instance-manager/getting-started/installation/migration/
- /nginx-instance-manager/installation/migration-guide/
---

{{< shortversions "2.0.0" "latest" "nimvers" >}}

{{< see-also >}}
To perform a clean installation of NGINX Management Suite (NMS) and Instance Manager, refer to the [NMS installation guide]({{< relref "installation/on-prem/_index.md" >}}).
{{< /see-also>}}

## Prerequisites

To complete this tutorial, you need the following:

- A host with Instance Manager v1 installed that's managing NGINX instances.

  {{< note >}}You'll need to install Instance Manager v2 on this same host in coexistence with Instance Manager v1. This allows you to migrate the managed NGINX instances to the newer version Verify that the host meets the [technical requirements for Instance Manager v2]({{< relref "/tech-specs.md" >}}).
  
  The package name for Instance Manager changed from `nginx-manager` to `nms-instance-manager`. You can run these packages in parallel.{{< /note >}}

## Migrate Instance Manager

Begin the migration process by installing Instance Manager v2.

1. Follow the instructions for [Installing Instance Manager]({{< relref "installation/on-prem/_index.md" >}}). License Instance Manager according to the installation guide.

1. Enable the NGINX Management Suite services:

    ```bash
    sudo systemctl enable nms
    sudo systemctl enable nms-core
    sudo systemctl enable nms-dpm
    sudo systemctl enable nms-ingestion
    sudo systemctl enable nms-integrations
    ```

1. Start the NGINX Management Suite services:

    ```bash
    sudo systemctl start nms
    sudo systemctl start nms-core
    sudo systemctl start nms-dpm
    sudo systemctl start nms-ingestion
    sudo systemctl start nms-integrations
    ```

    NGINX Management Suite components started this way run by default as the non-root `nms` user inside the `nms` group, both of which are created during installation.

1. To verify the NGINX Management Suite services are running, run the following command:

    ```bash
    ps aufx | grep nms
    ```

1. (Optional) After the installation finishes, you need to migrate any customized configurations.

   Refer to the following table for mapping Instance Manager v1 properties to their v2 equivalents. For Instance Manager v2, the properties are split between Instance Manager's configuration file (`nms.conf`) and the NGINX proxy instance's configuration (`nms-http.conf`).

{{<bootstrap-table "table table-striped table-bordered">}}
| Instance Manager v1 property | Instance Manager v2 equivalent | Configuration file                |
| ---------------------------------- | ------------------------------------ | --------------------------------- |
| `beacon.address`                   | DEPRECATED                           | N/A                               |
| `beacon.batch_size`                | DEPRECATED                           | N/A                               |
| `beacon.flush_interval`            | DEPRECATED                           | N/A                               |
| `beacon.token`                     | DEPRECATED                           | N/A                               |
| `bind_address`                     | `server.listen`                      | _/etc/nginx/conf.d/nms-http.conf_ |
| `cert`                             | `server.ssl_certificate`             | _/etc/nginx/conf.d/nms-http.conf_ |
| `gateway_port`                     | `server.listen`                      | _/etc/nginx/conf.d/nms-http.conf_ |
| `grpc_port`                        | `dpm.grpc_addr`                      | _/etc/nms/nms.conf_               |
| `influxdb.address`                 | DEPRECATED                           | N/A                               |
| `influxdb.batch_size`              | DEPRECATED                           | N/A                               |
| `influxdb.bucket`                  | DEPRECATED                           | N/A                               |
| `influxdb.flush_interval`          | DEPRECATED                           | N/A                               |
| `influxdb.gzip`                    | DEPRECATED                           | N/A                               |
| `influxdb.org`                     | DEPRECATED                           | N/A                               |
| `influxdb.tls.ca`                  | DEPRECATED                           | N/A                               |
| `influxdb.tls.cert`                | DEPRECATED                           | N/A                               |
| `influxdb.tls.enable`              | DEPRECATED                           | N/A                               |
| `influxdb.tls.key`                 | DEPRECATED                           | N/A                               |
| `influxdb.token`                   | DEPRECATED                           | N/A                               |
| `installer.dir`                    | DEPRECATED                           | N/A                               |
| `installer.filename`               | DEPRECATED                           | N/A                               |
| `installer.port`                   | DEPRECATED                           | N/A                               |
| `installer.username`               | DEPRECATED                           | N/A                               |
| `key`                              | `server.ssl_certificate_key`         | _/etc/nginx/conf.d/nms-http.conf_ |
| `license`                          | DEPRECATED                           | N/A                               |
| `log.level`                        | `log.level`                          | _/etc/nms/nms.conf_               |
| `log.path`                         | DEPRECATED                           | N/A                               |
| `metrics.storage-path`             | DEPRECATED                           | N/A                               |
| `rbac`                             | DEPRECATED                           | N/A                               |
| `scanner.host_discovery`           | DEPRECATED                           | N/A                               |
| `scanner.icmp_timeout`             | DEPRECATED                           | N/A                               |
| `scanner.tcp_timeout`              | DEPRECATED                           | N/A                               |
| `server_name`                      | `server.server_name`                 | _/etc/nginx/conf.d/nms-http.conf_ |
| `skip_validation`                  | DEPRECATED                           | N/A                               |
{{</bootstrap-table>}}

{{< important >}}The default `dpm_grpc_addr` value uses Unix domain sockets. We advise against replacing the default value.

Also, the license must be passed using the Instance Manager REST API or web interface and is no longer configurable.{{< /important >}}

After you've updated the configuration, you can migrate the managed NGINX instances. To do this, upgrade the NGINX Agents from v1 to v2. See the instructions in the following section for how to migrate the NGINX Agents.

## Upgrade the NGINX Agent

To upgrade the NGINX Agent from v1 to v2, take the following steps:

1. Follow the instructions to [Install NGINX Agent v2]({{< ref "nginx-agent/install-nginx-agent.md" >}}).

2. After the installation finishes, restart the NGINX Agent:

    ```bash
    sudo systemctl restart nginx-agent
    ```

3. Continue to the next section to migrate the managed NGINX instances to Instance Manager v2.

## Transfer Managed NGINX Instances

After each NGINX Agent has been upgraded to v2, the managed instance should appear in the "Inventory" view for Instance Manager v2. The managed NGINX instance no longer appears as `Connected` in the Instance Manager v1 "Inventory" view.

After you finish migrating all of the managed NGINX instances, you can uninstall the Instance Manager v1.

To uninstall Instance Manager v1, take the following steps:

1. Stop the Instance Manager v1 service:

    ```bash
    sudo systemctl stop nginx-manager
    ```

2. Uninstall Instance Manager v1:

    {{<tabs name="uninstall_nim">}}
    {{%tab name="CentOS, RHEL, and RPM-Based"%}}

  ```bash
  sudo yum remove nginx-manager 
  ```

    {{%/tab%}}
    {{%tab name="Debian, Ubuntu, and Deb-Based"%}}

  ```bash
  sudo apt-get remove nginx-manager
  ```

    {{%/tab%}}
    {{</tabs>}}
