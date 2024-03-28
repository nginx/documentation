---
description: Learn about the NGINX Controller Agent.
docs: DOCS-508
doctypes:
- concept
tags:
- docs
title: Get to Know the NGINX Controller Agent
toc: true
weight: 100
---

## Overview

The NGINX Controller Agent is a compact application written in Golang. NGINX Controller uses the Controller Agent to manage and monitor each NGINX Plus instance that the Agent is installed on. Once installed, the NGINX Controller Agent collects metrics and metadata and sends them securely to NGINX Controller for storage and visualization.

## How NGINX Controller Agent Works

You need to [install the NGINX Controller Agent]({{< relref "/controller/admin-guides/install/install-nginx-controller-agent.md" >}}) on all of the hosts you'd like to monitor.

Once installed, the NGINX Controller Agent automatically starts to report metrics. You should see the real-time metrics data in the NGINX Controller user interface after about one minute.

There's no need to manually add or configure anything in the NGINX Controller user interface after installing the Agent. When the Agent is started, the metrics and the metadata are automatically reported to NGINX Controller and are visualized in the user interface. You can, however, [configure the NGINX Controller Agent]({{< relref "/controller/admin-guides/config-agent/configure-the-agent.md" >}}) to customize how it collects and reports metrics.

All communications between the NGINX Controller Agent and the backend are done securely over SSL/TLS. All traffic is always initiated by the NGINX Controller Agent. The backend system doesn't set up any connections back to the NGINX Controller Agent.

## Detecting and Monitoring NGINX Instances

The NGINX Controller Agent attempts to detect and monitor all unique NGINX process instances running on a host and collects a separate set of metrics and metadata for each. The Agent uses the following qualifications to identify unique NGINX instances:

- A unique control process and its workers, started with an **absolute path** to a distinct NGINX binary.
- A control process running with a default config path, or with a custom path set in the command-line parameters.

{{< caution >}}You should not make manual changes to the `nginx.conf` file on NGINX Plus instances that are managed by NGINX Controller. Manually updating the `nginx.conf` file on managed instances may adversely affect system performance. In most cases, NGINX Controller will revert or overwrite manual updates made to `nginx.conf`.{{< /caution >}}

<br/>

## Supported Systems

{{< include "controller/supported-distributions.md" >}}

{{< see-also >}}
See the [NGINX Controller Technical Specifications]({{< relref "/controller/admin-guides/install/nginx-controller-tech-specs.md" >}}) for the complete list of system requirements for NGINX Controller and the NGINX Controller Agent.
{{< /see-also >}}

## Supported Python Versions

NGINX Controller and the NGINX Controller Agent versions 3.6 and earlier require Python 2.6 or 2.7. Python is not needed for NGINX Controller or the NGINX Controller Agent versions 3.7 and later.

## What's Next

- [Install the NGINX Controller Agent]({{< relref "/controller/admin-guides/install/install-nginx-controller-agent.md" >}})
- [Customize how the NGINX Controller Agent collects metrics]({{< relref "/controller/admin-guides/config-agent/configure-the-agent.md" >}})

{{< versions "3.0" "latest" "ctrlvers" >}}
{{< versions "3.18" "latest" "apimvers" >}}
{{< versions "3.20" "latest" "adcvers" >}}
