---
title: Update NGINX Amplify Agent
description: Learn how to update F5 NGINX Amplify Agent.
weight: 200
toc: true
docs: DOCS-970
---

{{< important >}}
It is *highly* recommended that you periodically check for updates and install the latest stable version of F5 NGINX Amplify Agent.
{{< /important >}}

 1. Updating NGINX Amplify Agent On Ubuntu/Debian

    ```bash
    apt-get update && \
    apt-get install nginx-amplify-agent
    ```

 2. Updating NGINX Amplify Agent On CentOS/Red Hat

    ```bash
    yum makecache && \
    yum update nginx-amplify-agent
    ```