---
description: These release notes contain information about new features, improvements,
  known issues, and bug fixes in the NGINX Controller API Management Module.
docs: DOCS-365
title: Release Notes 3.18.1
toc: true
weight: 99
type:
- reference
---

{{< include "controller/apim-rn-preamble.md" >}}

&nbsp;

---

July 23, 2021

## Upgrade Considerations

Take note of the following considerations when upgrading to this version of the NGINX Controller API Management Module:

- After upgrading NGINX Controller, make sure to upgrade the NGINX Controller Agent too.

- If you're upgrading NGINX Controller on a multi-node cluster, run the `update.sh` script on each node individually -- the order in which you update the nodes doesn't matter.

  {{< warning >}}Never update the control nodes in parallel. Doing so may result in race conditions for certain jobs, such as database migrations, and may cause the cluster to become unavailable.{{< /warning >}}

## Known Issues

The following issues are known to be present in this release. Look for updates to these issues in future release notes.

- **Upgrade from NGINX Controller v3.10 to NGINX Controller API Management Module v3.18.1 will fail (26957)**

  Upgrading NGINX Controller 3.10 to NGINX Controller API Management Module 3.x is not supported. Upgrade attempts will fail.

- **Additional steps required to upgrade Controller Agents when updating from NGINX Controller 3.9.0 to NGINX API Management Module 3.18.1 (27030)**

  After updating NGINX Controller 3.9 to NGINX APIM 3.18.1, it is not possible to upgrade the controller-agent completely without additional steps

  **Workaround:**

  To make sure that the Controller Agents are upgraded completely:

  - Upgrade NGINX Controller the normal documented way
  - Upgrade the Controller Agents the normal documented way

  At this stage you will see the Agents are still not online in the `Infrastructure > Instances` section and you will not be able to make config changes. Follow these additional steps to complete the upgrade:

  - ssh into each Instance and edit the `/etc/controller-agent/agent.conf` file and append the following lines in the `[cloud]` section, after the line `requests_ca_bundle =`

    ```text
    grpc = true
    grpc_common_server_name =
    grpc_command_server_name = dataplane-manager
    grpc_metrics_server_name = agent-ingest
    ```

  - Restart each controller-agent service with the command `sudo service controller-agent restart`.

  Now, in `Infrastructure > Instances`, the Instances will appear as Running and you can push config changes.

## Supported NGINX Plus Versions

NGINX Controller works with the following NGINX Plus versions:

- NGINX Plus R24
- NGINX Plus R23
- NGINX Plus R22
- NGINX Plus R21
- NGINX Plus R20
- NGINX Plus R19
