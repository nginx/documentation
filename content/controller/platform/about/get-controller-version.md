---
authors: []
categories:
- platform management
date: "2020-10-26T15:32:41-06:00"
description: How to look up the version details for NGINX Controller and its components
docs: DOCS-780
doctypes:
- task
draft: false
journeys:
- using
menu:
  docs:
    parent: Platform
personas:
- devops
- netops
- secops
- support
roles:
- admin
- user
tags:
- docs
title: Look Up Version Information
toc: true
weight: 130
---

## Overview

You can use the NGINX Controller command-line interface, web interface, and API to look up the version information for NGINX Controller. The NGINX Controller API also returns version information for the NGINX Controller components.

## Use helper.sh to Look Up Version Info

To look up the current version of NGINX Controller using the `helper.sh` script, run the following command:

```bash
/opt/nginx-controller/helper.sh version
```

The output looks similar to the following:

``` bash
Installed version: 3.14.0
Running version: 3.14.0
```

## Use the Web Interface to Look Up Version Info

1. Open the NGINX Controller user interface and log in.

2. Select the NGINX Controller menu icon, then select **Platform**.

3. On the Platform menu, select **Cluster** > **Overview**.

## Use the NGINX Controller API to Look Up Version Info

To use the [NGINX Controller REST API]({{< relref "api/_index.md" >}}) to look up version information, send a GET request to the `/platform/global` endpoint.

{{< versions "3.0" "latest" "ctrlvers" >}}
{{< versions "3.18" "latest" "apimvers" >}}
{{< versions "3.20" "latest" "adcvers" >}}
