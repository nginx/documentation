---
title: Technical Specifications
description: "NGINX Instance Manager Technical Specifications."
draft: false
weight: 300
toc: true
categories: ["reference"]
docs: "DOCS-639"
---

{{< include "nim/previous-versions/old-version-warning.md" >}}

{{%heading "overview"%}}

## NGINX Instance Manager Technical Specifications {#summary}

NGINX Instance Manager is available in binary form only; it is not available in source form. Please [inquire](https://www.nginx.com/contact-sales/?_ga=2.136205685.533281598.1609156985-420478116.1599571713) for additional platforms and modules.

### Supported Distributions {#distributions}

The Server and Agent can run on most environments. Supported distributions are listed below and should follow [NGINX Plus supported distributions](https://docs.nginx.com/nginx/technical-specs/#supported-distributions) excluding non-64bit.

{{<bootstrap-table "table table-striped table-bordered">}}

|  Distribution  |         Version         | Platform | rpm | deb | binary |
|:--------------:|:-----------------------:|:--------:|:---:|:---:|:------:|
| RHEL/CentOS    | 6,7,8                   | x86_64   |  X  |     |    X   |
| Debian         | 9,10                    | x86_64   |     |  X  |    X   |
| Ubuntu         | 16.04,18.04,20.04,20.10 | x86_64   |     |  X  |    X   |
| SLES           | 12,15                   | x86_64   |  X  |     |    X   |
| Alpine         | 3.10,3.11,3.12          | x86_64   |     |     |    X   |
| Amazon Linux   | 2018.03+                | x86_64   |  X  |     |    X   |
| Amazon Linux 2 | LTS                     | x86_64   |  X  |     |    X   |
| FreeBSD        | 11.4+,12.1+             | amd64    |     |     |    X   |
| Oracle Linux   | 7.4+                    | x86_64   |     |     |    X   |
| Fedora         | 30,31,32,33             | x86_64   |  X  |     |    X   |

{{</bootstrap-table>}}

### Supported Deployment Environments {#environments}

- Bare Metal
- Container
- Public Cloud: AWS, Google Cloud Platform, Microsoft Azure
- Virtual Machine

### Recommended Hardware {#hardware}

Minimum Server Sizing

- 1 CPU Core
- 1 GB RAM
- 1GbE NIC
- 20GB HDD

Recommended Server Sizing for up to 250 instances:

- 2 CPU Cores
- 4 GB RAM
- 1GbE NIC
- 80GB HDD (use 20GB or less for root and 60GB for /var/nginx-manager, /var/log/nginx-manager)

Recommended Server Sizing for up to 1000 instances:

- 4 CPU Cores
- 8 GB RAM
- 1GbE NIC
- 220 GB HDD (use 20GB or less for root and 200GB for /var/nginx-manager, /var/log/nginx-manager)

The sizing is based on several factors and should be adjusted accordingly. The above suggestions are guidelines only. You can support more instances with high core, memory, and disk IOP/space.

### Storage Sizing {#storage}

NGINX Instance Manager is distributed as a package sized under 25MB but doesn't include the logs and database files that may grow on a system. To handle this, we recommend splitting up the partitions on your system and minimally putting the three directories on one partition or placing them in 3 partitions separately.

{{<bootstrap-table "table table-striped table-bordered">}}

|     Directory     |           Usage          |   Growth  |    IOPS   |
|:-----------------:|:------------------------:|:---------:|:---------:|
| /var/nginx-manager      | VictoriaMetrics Database and Cache for UI and Scan    |   Very High | Very High |
| /var/logs/nginx-manager | Log files                |    High   |    High   |

{{</bootstrap-table>}}

Minimally, you should allocate 20 GB across the directories, especially to the /var/nginx-manager, which will consume the most space and IOPS.

The Log directory will grow based on the number of instances you collect; IOPS and growth will scale accordingly.

### Logging {#logging}

NGINX Instance Manager Server uses the system logging to place log files, usually in `/var/log/nginx-manager`. Using a separate partition and/or log rotation can help prevent your system from running out of space due to log growth.

NGINX Agent uses the log files and formats to collect metrics. Expanding the log formats and instance counts will also increase the size of the log files on the agent. Adding a separate partition for /var/log/nginx-agent is always a good idea. Without log rotation or a separated partition, a log directory could cause your system to run out of space.

### NGINX Versions {#nginx-versions}

NGINX Agents should run on almost every version we have, but we do restrict support to the following. If you have a good reason to run this on an earlier version, let support know, and we can look to include it. Just because a version is not listed does not mean NGINX Instance Manager won't run; it means we just don't test against it and therefore can't claim to support it.

If you run a custom build (that is, you compiled it yourself), check with NGINX Support if you have concerns about what's supported. The table below assumes distributed binaries for version, but we can work with you on exceptions if necessary. Ideally, ask about this before purchasing.

NGINX Plus Versions:

- R21
- R22
- R23

NGINX Open Source Versions:

- 1.16
- 1.18
- 1.19

### NGINX Directives and Configurations {#nginx-directives}

NGINX Instance Manager supports every [directive](https://nginx.org/en/docs/dirindex.html) and every configuration that NGINX Open Source and Plus can run. If NGINX can run it, we can handle it. Due to the complexity and number of options, we use subsets of configurations and options to test. If you find a configuration or directive that isn't working correctly with the agent, contact NGINX Support to let us know.

Number of known configuration exceptions: 0

- this list item was intentionally left blank

### Supported Browsers {#browsers}

NGINX Instance Manager works best on the newest and the last prior version of these browsers

- [Google Chrome](https://www.google.com/chrome/)
- [Firefox](https://www.mozilla.org/en-US/firefox/new/)
- [Safari](https://support.apple.com/downloads/safari)
- [Internet Explorer](https://support.microsoft.com/en-us/help/17621/internet-explorer-downloads)
- [Microsoft Edge](https://www.microsoft.com/en-us/edge)

### Firewall Ports {#firewall}

Configure the NGINX Instance Manager Server with the following firewall settings.

{{<bootstrap-table "table table-striped table-bordered">}}

|    Port   |   src  |    dest   | Description                                                                                                                           |
|:---------:|:------:|:---------:|---------------------------------------------------------------------------------------------------------------------------------------|
| 10000/TCP | Server | Agent     | gRPC communication (change to your proxy port if using NGINX Plus)                                                                    |
| 11000/TCP | Server | any       | GUI and API port, open externally to users restrict to known range (change to your proxy port if using NGINX Plus)                    |
| 10000/TCP | Agent  | Server    | gRPC communication                                                                                                                    |
| 8080/TCP  | Agent  | localhost | NGINX Plus API or NGINX OSS Stub Status Page (change to your published port, you do not need to expose this externally to the server) |

{{</bootstrap-table>}}
