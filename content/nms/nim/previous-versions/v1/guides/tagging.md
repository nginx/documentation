---
title: "Tagging"
date: 2021-06-09T11:52:09-07:00
draft: false
description: "NGINX Instance Manager Tagging Documentation"
# Assign weights in increments of 100
weight: 300
toc: true
tags: [ "docs" ]
# Taxonomies
# These are pre-populated with all available terms for your convenience.
# Remove all terms that do not apply.
categories: ["installation"]
doctypes: ["tutorial"]
journeys: ["getting started", "using"]
personas: ["devops", "netops", "secops", "support"]
versions: []
docs: "DOCS-634"
---

{{< include "nim/previous-versions/old-version-warning.md" >}}

{{%heading "overview"%}}

This document explains how to use tagging with NGINX Instance Manager.

# {{%heading "tagging"%}}

## How it works {#how-it-works}

Tagging is a feature designed to help group a larger number of instances within NGINX Instance Manager. Tagging serves three purposes:
1. Provide labeling to groups of instances for similar configurations.
2. Enable OpenID Connect users to limit access to groups of instances.
3. Provide a way to group metrics based on a tag.

A tag is a free-form label that Instance Manager uses to group more than one instance. In addition, an instance may contain more than one tag.

## Adding a tag {#add-tag}

There are two methods to add a tag to an instance.

### Configuration File {#add-tag-config}

The `nginx-agent.conf` file can be used to add a tag to an instance. These tags will always show up during registration and won't be removed from the UI (even if you attempt to remove them in the UI, the agent will add them back upon a restart). To add tags to the configuration, edit the `nginx-agent.conf` and include the tags in a list under the key `tags:`.

```yaml {hl_lines=["30-32"]}
#
# /etc/nginx-agent/nginx-agent.conf
#

# Configuration file for NGINX Agent

# specify the server gRPC port to connect to
server: nginx-manager.example.com:10443
metrics-mode: nim

# tls options
tls:
  # enable tls in the nginx-manager setup for grpcs
  enable: true
  # path to certificate
  cert: /etc/ssl/nginx-manager/agent.crt
  # path to certificate key
  key: /etc/ssl/nginx-manager/agent.key
  # path to CA cert
  ca: /etc/ssl/nginx-manager/ca.pem
log:
  # set log level (panic, fatal, error, info, debug, trace; default: info) (default "info")
  level: info
  # set log path. if empty, don't log to file.
  path: /var/log/nginx-agent/
# (optional) tags for this specific instance / machine for inventory purposes
metadata:
  location: unspecified
# instance tags
tags:
- web
- staging
# list of allowed config directories (comma-separated)
config_dirs: /etc/nginx,/usr/local/etc/nginx
# nginx configuration options
nginx:
  # path of nginx to manage
  bin_path: /usr/sbin/nginx
  # specify stub status URL (see: nginx.org/r/stub_status)
  stub_status "http://127.0.0.1:80/nginx_status"
  # specify plus status api url (see nginx.org/r/api)
  plus_api: "http://127.0.0.1:8080/api"
  # specify metrics poll interval
  metrics_poll_interval: 1000ms
  # specify access logs to exclude from metrics (comma separated)
  #exclude_logs: /var/log/nginx/skipthese*,/var/log/nginx/special-access.log
```

To have the tags take effect, restart the nginx-agent service.

### Add tags using UI {#add-tags-UI}

You can also use the web interface to add tags to instances.

Select the instance row to open the slide-out panel.

Enter the tags you want to use or select an existing tag.

Select the "X" next to the tag to remove its association with an instance.

## Using a tag to push to multiple instances {#tag-publish}

NGINX Instance Manager can use tags to copy an nginx configuration to multiple instances with the same tag in common.

Select the **Tags** button on the inventory page to use this function in the web interface. Then, in the panel that's displayed, copy the configuration from one instance to the other instances.

Select the instance you want to use as the source and the tag to push out.

You can then clone the configuration to the other instances. This saves the configuration in the Instance Manager database but does not write the configuration to the instance disk yet. To write the configuration to the instance and publish the changes, select **Publish**.

## Using tags with access control {#tag-rbac}

You can use tags to control or restrict access to tagged instances. This feature is currently in Tech Preview and is described in more detail on the [authentication]({{<relref "/nim/previous-versions/v1/getting-started/auth.md">}}) page.

## Using tags with metrics {#tag-metric}

Tags can also be used with metrics. To prevent exponential growth, tags are provided as a comma-separated list of tags that can be used to filter per instance. Labels can be added if desired, but the effect does increase storage usage.
