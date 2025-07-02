---
title: Uninstall NGINX Amplify Agent
description: Learn how to uninstall F5 NGINX Amplify Agent.
weight: 400
toc: true
nd-docs: DOCS-969
---

To completely delete a previously monitored object, perform the following steps:


### Uninstall F5 NGINX Amplify Agent

- On Ubuntu/Debian use:

    ```bash
    apt-get remove nginx-amplify-agent
    ```

- On CentOS and Red Hat use:

    ```bash
    yum remove nginx-amplify-agent
    ```

### Delete objects from the web interface

To delete a system using the web interface — find it in the [Inventory]({{< ref "/amplify/user-interface/inventory" >}}), and click on the "Trash" icon.

Deleting objects in the UI will not stop NGINX Amplify Agent. To completely remove a system from monitoring, stop and uninstall NGINX Amplify Agent first, then clean it up in the web interface.

### Delete alerts

  Check the [Alerts]({{< ref "/amplify/user-interface/alerts" >}}) page and remove or mute the irrelevant rules.
