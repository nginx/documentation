---
title: "Scan"
date: 2020-12-17T11:52:09-07:00
draft: false
description: "NGINX Scan Documentation"
# Assign weights in increments of 100
weight: 300
toc: true
tags: [ "docs" ]
# Taxonomies
# These are pre-populated with all available terms for your convenience.
# Remove all terms that do not apply.
categories: ["installation", "analytics"]
doctypes: ["tutorial"]
journeys: ["getting started", "using"]
personas: ["devops", "netops", "secops", "support"]
versions: []
docs: "DOCS-633"
---

{{< include "nim/previous-versions/old-version-warning.md" >}}

{{%heading "overview"%}}

This document explains how to use scan in NGINX Instance Manager.

## Prerequisites {#prerequisites}

1. Install NGINX Instance Manager Server.
2. Install NGINX or NGINX Plus and the NGINX Agent.
3. Start and Enable Instance Manager.

# {{%heading "scan"%}}

{{<note>}}
To update the CVE List manually or offline, refer to the [offline]({{<relref "offline.md#cve-check">}}) guide.
{{</note>}}

## Scan from the UI {#scan-ui}

Open the user interface on `https://nginx-manager.example.com:11000/api/v0` (or similar) and select the **Scan** tab.

You can enter subnets and masks that correspond to your network.

{{<note>}}
To scan a single address, use the netmask of `/32` after the IP. This is the equivalent of scanning a single subnet. If you enter the wrong subnet, the scan may take longer than expected before erroring.

There is a CVE not reported for NGINX that involves [unfiltered logging](https://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2009-4487). This won't be fixed and has a severity of "None" and is excluded from our scans' CVE list.
{{</note>}}

When you run the scan, another binary is called that uses Nmap to scan the network. We use the stealth scan of Nmap to do this. You can read more about Nmap and service scanning on the [Nmap website](https://nmap.org/book/vscan.html).

## Scan from the API {#scan-api}

Call the API on https://nginx-manager.example.com:11000 and run something similar to the following call.

```bash
curl -X POST "https://nginx-manager.example.com/api/v0/scan" -H  "accept: application/json" -H  "Content-Type: application/json" -d "{  \"cidr\": \"10.1.1.0/24\",  \"ports\": [    80  ]}"
```

This should present you with a response similar to the one below.

```json
{
  "status": "complete",
  "err": null,
  "cancelled": false,
  "request_args": {
    "cidr": "10.1.1.0/24",
    "ports": [
      80
    ]
  },
  "duration": "4.477998519s",
  "scan_percentage_complete": "100%",
  "ips_scanned": 254,
  "fingerprint_percentage_complete": "100%",
  "servers_found": 6,
  "nginx_found": 5
}
```

To get the scanned servers, you can run something similar to the following call:

```bash
curl -X GET "https://nginx-manager.example.com/api/v0/servers" -H  "accept: application/json"
```

This should present you with a response similar to the one below.

```json
{
  "listinfo": {
    "limit": 0,
    "offset": 0,
    "total": 6
  },
  "list": [
    {
      "instance_id": "",
      "ip": "10.1.1.5",
      "port": "80",
      "app": "nginx",
      "version": "1.16.1",
      "fingerprinted": false,
      "cves": -1,
      "managed_id": "0338af1176ba716e13a9966410b1696173c50c308bacfb7c3fbc0283984b137a",
      "lastseen": "2021-01-04T14:46:52.808815743Z",
      "added": "2021-01-04T14:46:52.808817629Z"
    },
    {
      "instance_id": "",
      "ip": "10.1.1.6",
      "port": "80",
      "app": "nginx",
      "version": "1.14.0",
      "fingerprinted": false,
      "cves": -1,
      "managed_id": "e9df2c501d7ddb96371c5342d22492cc94c57480e604400619dd6f81a9344f8a",
      "lastseen": "2021-01-04T14:46:52.816269655Z",
      "added": "2021-01-04T14:46:52.816271596Z"
    },
    {
      "instance_id": "",
      "ip": "10.1.1.7",
      "port": "80",
      "app": "nginx",
      "version": "1.19.5",
      "fingerprinted": false,
      "cves": 0,
      "managed_id": "5950a5b39b619ea118fdbc94f9f2900b089b284544f64432bff18b6beb6f71ed",
      "lastseen": "2021-01-04T14:46:52.818860942Z",
      "added": "2021-01-04T14:46:52.818862892Z"
    },
    {
      "instance_id": "",
      "ip": "10.1.1.8",
      "port": "80",
      "app": "nginx",
      "version": "1.19.5",
      "fingerprinted": false,
      "cves": 0,
      "managed_id": "6628bfc80d3afd984c63344df99221b428103f62ff4d12adca7b1639da6b1edb",
      "lastseen": "2021-01-04T14:46:52.997624506Z",
      "added": "2021-01-04T14:46:52.997626552Z"
    },
    {
      "instance_id": "",
      "ip": "10.1.1.10",
      "port": "80",
      "app": "nginx",
      "version": "1.19.5",
      "fingerprinted": false,
      "cves": 0,
      "managed_id": "",
      "lastseen": "2021-01-04T14:46:53.174520650Z",
      "added": "2021-01-04T14:46:53.174522473Z"
    },
    {
      "instance_id": "",
      "ip": "10.1.1.254",
      "port": "80",
      "app": "",
      "version": "",
      "fingerprinted": false,
      "cves": -1,
      "managed_id": "",
      "lastseen": "2021-01-04T14:46:53.291044599Z",
      "added": "2021-01-04T14:46:53.291046688Z"
    }
  ]
}
```
