---
description: Learn about the NGINX Controller Agent.
docs: DOCS-508
title: Get to Know the F5 NGINX Controller Agent
toc: true
weight: 100
type:
- concept
---

## Overview

The F5 NGINX Controller Agent is a compact application written in Golang. NGINX Controller uses the Controller Agent to manage and monitor each NGINX Plus instance that the Agent is installed on. Once installed, the NGINX Controller Agent collects metrics and metadata and sends them securely to NGINX Controller for storage and visualization.

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

NGINX Controller, the NGINX Controller Agent, and the NGINX Controller Application Security Add-on support the following distributions and architectures.

{{< see-also >}}Refer to the [NGINX Plus Technical Specifications](https://docs.nginx.com/nginx/technical-specs/) guide for the distributions that NGINX Plus supports.{{< /see-also >}}

{{< bootstrap-table "table table-striped table-bordered" >}}

|Distribution<br>and Version|NGINX Controller <br> (Control Plane)|Agent <br> (Data Plane)|ADC App. Sec.<br>(Data Plane)|APIM Adv. Sec.<br>(Data Plane)|Notes|
|--- |--- |--- |--- |--- |--- |
|Amazon Linux<br>2<br>(x86_64)| Not supported|v3.0+ |Not supported|Not supported| |
|Amazon Linux<br>2017.09+<br>(x86_64)| Not supported |v3.0+|Not supported |Not supported| |
|CentOS<br>6.5+<br>(x86_64)| Not supported |v3.0+| Not supported |Not supported| &#8226; CentOS 6.5 and later versions in the CentOS 6 family are partially supported. <br> &#8226; This distribution does not support <a href="#avrd">AVRD</a>.|
|CentOS<br>7.4+<br>(x86_64)|v3.0+|v3.0+ | v3.12+ |v3.19+| &#8226; CentOS 7.4 and later versions in the CentOS 7 family are supported.|
|Debian<br>8<br>(x86_64)| Not supported |v3.0–3.21|Not supported|Not supported|&#8226; This distribution does not support <a href="#avrd">AVRD</a>.|
|Debian<br>9<br>(x86_64)|v3.0+|v3.0–3.21 | v3.12+ |v3.19+ | |
|Debian<br>10<br>(x86_64)| Not supported |v3.17+ | v3.17+ |v3.19+| See the [NGINX Plus Admin Guide](https://docs.nginx.com/nginx/) for requirements for Debian 10. |
|Red Hat Enterprise Linux<br>6.5+| Not supported |v3.0+| Not supported | Not supported| &#8226; RHEL 6.5 and later versions in the RHEL 6 family are partially supported.|
|Red Hat Enterprise Linux<br>7.4+<br>(x86_64)|v3.5+|v3.5+ | v3.12+|v3.19+| &#8226; RHEL 7.4 and later versions in the RHEL 7 family are supported.<br>&#8226; SELinux may interfere with NGINX Controller installation and operation. If you do enable SELinux, it must use permissive mode. Use of enforcing mode is not supported. |
|Red Hat Enterprise Linux<br>8.0+<br>(x86_64)|v3.22+|v3.22+ | v3.22+| Not supported | &#8226; RHEL 8.0 and later versions in the RHEL 8 family are supported. <br>&#8226; SELinux may interfere with NGINX Controller installation and operation. If you do enable SELinux, it must use permissive mode. Use of enforcing mode is not supported. |
|Ubuntu<br>18.04 LTS<br>(x86_64)|v3.0+|v3.0+ |v3.13+|v3.19+| |
|Ubuntu<br>20.04 LTS<br>(x86_64)|v3.20+|v3.12+|v3.16.1+|v3.19+| |

{{< /bootstrap-table >}}


<a name="avrd"></a>

#### Analytics, Visibility, and Reporting Daemon (AVRD)

NGINX Controller v3.1 and later use an Analytics, Visibility, and Reporting daemon (AVRD) to aggregate and report app-centric metrics, which you can use to track and check the health of your apps. To learn more about these metrics, see the [NGINX Metrics Catalog]({{< relref "/controller/analytics/catalogs/metrics.md" >}}) topic.

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
