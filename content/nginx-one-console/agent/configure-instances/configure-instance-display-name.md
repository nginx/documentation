---
title: Assign a display name to an instance
toc: true
weight: 500
f5-content-type: how-to
f5-docs: DOCS-000
f5-product: NGINX Agent
---

## Overview

By default, NGINX One Console identifies each NGINX instance by its hostname. You can assign a friendlier, custom name to an instance by setting the reserved `display-name` NGINX Agent label. Once NGINX Agent reports the label, NGINX One Console shows the display name alongside the hostname, and you can use it to filter and sort your instances.

## Before you begin

Before you start, make sure that you have:

- [NGINX Agent installed]({{< ref "/nginx-one-console/agent/install-upgrade/" >}}) and connected to NGINX One Console.
- Access to the NGINX Agent configuration file, CLI, or container environment.

## Set a display name

Set the `display-name` label using any of the [NGINX Agent label]({{< ref "/nginx-one-console/agent/configure-instances/configuration-overview.md" >}}) configuration sources.

### Configuration file

Add the label to the `labels` section of `/etc/nginx-agent/nginx-agent.conf`:

```yaml
labels:
  display-name: prod-usw2-edge-03
```

### CLI parameters

```shell
nginx-agent --labels=display-name=prod-usw2-edge-03
```

### Environment variables

```shell
export NGINX_AGENT_LABELS="display-name=prod-usw2-edge-03"
```

After you save your changes, restart NGINX Agent to apply them:

```shell
sudo systemctl restart nginx-agent
```

{{< call-out class="note" >}}
The display name can be up to 256 characters long. A value longer than this is rejected, and the instance keeps registering without a display name.
{{< /call-out >}}

## Where the display name appears

Once NGINX Agent reports the `display-name` label, NGINX One Console uses it in the following places:

- The **Instances** list and **Instance details** page, alongside the hostname.
- Instance filters and sort options, so you can find instances by display name.
- Data Plane Key details, Config Sync Group instance lists, and Staged Config publish flows.
- Instance metrics dashboards and F5 WAF for NGINX security events, where available.

If an instance doesn't have a display name set, NGINX One Console continues to show its hostname.
