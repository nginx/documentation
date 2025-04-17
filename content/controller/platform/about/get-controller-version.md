---
description: How to look up the version details for F5 NGINX Controller and its components.
docs: DOCS-780
title: Look Up Version Information
toc: true
weight: 130
type:
- how-to
---

## Overview

You can use the F5 NGINX Controller command-line interface, web interface, and API to look up the version information for NGINX Controller. The NGINX Controller API also returns version information for the NGINX Controller components.

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

To use the [NGINX Controller REST API]({{< ref "/controller/api/_index.md" >}}) to look up version information, send a GET request to the `/platform/global` endpoint.

{{< versions "3.0" "latest" "ctrlvers" >}}
{{< versions "3.18" "latest" "apimvers" >}}
{{< versions "3.20" "latest" "adcvers" >}}
