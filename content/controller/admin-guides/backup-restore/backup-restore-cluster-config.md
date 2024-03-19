---
authors: []
categories:
- installation
- platform management
date: "2020-12-06T13:55:05-08:00"
description: Learn how to back up your NGINX Controller cluster configuration and encryption keys.
docs: DOCS-247
doctypes:
- task
draft: false
journeys:
- getting started
- using
- self service
personas:
- devops
- netops
- secops
roles:
- admin
tags:
- docs
title: Back Up & Restore Cluster Config and Encryption Keys
toc: true
weight: 97
---

## Overview

After installing NGINX Controller, you should back up the cluster config and encryption keys. You'll need these if you ever need to restore the NGINX config database on top of a new NGINX Controller installation.

- To back up the NGINX Controller cluster configuration and encryption keys:

  ```bash
  /opt/nginx-controller/helper.sh cluster-config save
  ```

  The file is saved to `/opt/nginx-controller/cluster-config.tgz`.

- To restore the cluster's config and encryption keys, take the following steps:

  ```bash
  /opt/nginx-controller/helper.sh cluster-config load <filename>
  ```

{{< versions "3.12" "latest" "ctrlvers" >}}
{{< versions "3.18" "latest" "apimvers" >}}
{{< versions "3.20" "latest" "adcvers" >}}
