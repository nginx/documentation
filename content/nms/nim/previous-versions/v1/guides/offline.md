---
title: "Offline Installation"
date: 2021-06-09T11:52:09-07:00
draft: false
description: "This document explains how to install NGINX Instance Manager in an offline environment."
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
docs: "DOCS-632"
---

{{< include "nim/previous-versions/old-version-warning.md" >}}

{{%heading "overview"%}}

# {{%heading "offline"%}}

NGINX Instance Manager is designed to run without internet access in most cases.

## Install from packages {#scan-ui}

To install offline, you need to manually download the package and license files. Follow the installation instructions for the [server]({{<relref  "install.md">}}) and [agent]({{<relref "agent.md">}}).

All dependencies are included with the packages.

## CVE Checking {#cve-check}

We do connect to the internet to get a list of the current CVEs to use with the [scan function]({{<relref "/nms/nim/previous-versions/v1/guides/scan-v1.md">}}). To manually update this list, you can download and overwrite the `cve.xml` file in the `/usr/share/nginx-manager` directory.

Download the cve file

```bash
$ curl -s http://hg.nginx.org/nginx.org/raw-file/tip/xml/en/security_advisories.xml > /usr/share/nginx-manager/cve.xml
```

Rerun the scan. If it is not picked up, you may need to restart the nginx-manager service; however, NGINX Instance Manager is designed to check the internet for a copy and then use the local copy if it cannot be found. Run the curl command and change the location it writes to, then copy the file into that directory on the nginx-manager server. This updated the CVE list for NGINX Scan functions.
