---
title: Install from GitHub package files
toc: true
weight: 300
nd-docs: DOCS-1876
---

{{< call-out "note" >}}
If you are using [NGINX One Console]({{< ref "/nginx-one/getting-started.md" >}})
to manage your NGINX instances, NGINX Agent is installed automatically when you
add an NGINX instance to NGINX One Console.

For a quick guide on how to connect your instance to NGINX One Console see: [Connect to NGINX One Console]({{< ref "/nginx-one/connect-instances/add-instance.md" >}})
{{< /call-out >}}

Follow the steps in this guide to install NGINX Agent in your NGINX instance using
GitHub package files.

## Before you begin

{{< include "/agent/installation/prerequisites.md" >}}

## GitHub package files

To install NGINX Agent on your system using GitHub package files, go to the
[GitHub releases page](https://github.com/nginx/agent/releases) and download the
latest package supported by your operating system distribution and CPU architecture.

Use your system's package manager to install the package. Some examples:

- Debian, Ubuntu, and other distributions using the `dpkg` package manager.

   ```shell
   sudo dpkg -i nginx-agent-<agent-version>.deb
   ```

- RHEL, CentOS RHEL, Amazon Linux, Oracle Linux, and other distributions using
   the `yum` package manager

  ```shell
  sudo yum localinstall nginx-agent-<agent-version>.rpm
  ```

- RHEL and other distributions using the `rpm` package manager

  ```shell
  sudo rpm -i nginx-agent-<agent-version>.rpm
  ```

- Alpine Linux

  ```shell
  sudo apk add nginx-agent-<agent-version>.apk
  ```

### Manually connect NGINX Agent to NGINX One Console

{{< include "agent/installation/manually-connect-to-console" >}}

## Start, stop, and enable NGINX Agent

{{< include "/agent/installation/start-stop-agent.md" >}}

## Verify that NGINX Agent is running

{{< include "/agent/installation/verify-agent.md" >}}