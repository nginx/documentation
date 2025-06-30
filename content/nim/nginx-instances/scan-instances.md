---
description: Follow the steps in this guide to scan for and discover NGINX instances.
nd-docs: DOCS-828
title: Scan and discover NGINX instances
toc: true
weight: 110
type:
- tutorial
---

<style>
  h3 {font-weight: 400; padding-top: 20px;}
  hr {margin-top: 40px; margin-bottom: 40px;}
</style>

{{< shortversions "2.0.0" "latest" "nimvers" >}}

## Prerequisites {#prerequisites}

1. [Install Instance Manager]({{< ref "/nim/deploy/vm-bare-metal/_index.md" >}}).
2. Start and enable Instance Manager.

{{<note>}}
To update the CVE list manually or offline, refer to the [Offline Installation]({{<ref "/nim/disconnected/offline-install-guide.md#cve-check">}}) guide.
{{</note>}}

Host discovery, the first stage in instance discovery, is used to enumerate live hosts on a given network. However, in certain environments, Internet Control Message Protocol (ICMP) echo requests are disabled. The Instance Manager API provides a method for disabling host discovery in scanning.

```shell
curl --request POST \
  --url https://<NGINX-INSTANCE-MANAGER-FQDN>/api/platform/v1/servers/scan \
  --header 'Authorization: Bearer <access token>.' \
  --header 'content-type: application/json' \
  --data '{"cidr": "192.0.2.0/24","hostDiscovery": "none","portRanges": ["80","443"]}'
```

If no host discovery options are provided, Instance Manager sends an ICMP echo request to each host on the network.

## Scan using the web interface {#scan-ui}

1. In a web browser, go to the FQDN for your F5 NGINX Management Suite host and log in.
2. In the left menu, select **Scan**.
3. Enter subnets and masks that correspond to your network.

{{<note>}}
To scan a single address, use the netmask of `/32` after the IP. This is the equivalent of scanning a single subnet. If you enter the wrong subnet, the scan may take longer than expected before erroring.

There's a CVE that's not reported for NGINX that involves [unfiltered logging](https://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2009-4487). This CVE won't be fixed, has a severity of "None," and is excluded from our scans' CVE list.
{{</note>}}

---

## Scan using the API {#scan-api}

To start a scan using the Instance Manager API, send a POST request similar to the following example to the Scan endpoint, `https://<NGINX-INSTANCE-MANAGER-FQDN>/api/platform/v1/servers/scan`.

```shell
curl --request POST \
  --url https://<NGINX-INSTANCE-MANAGER-FQDN>/api/platform/v1/servers/scan \
  --header 'Authorization: Bearer <access token>' \
  --header 'content-type: application/json' \
  --data '{"cidr": "192.0.2.0/24","portRanges": ["80","443"]}'
```

The response looks similar to the following example:

```json
{
  "completionTime": "2021-12-02T00:27:34.517919044Z",
  "duration": 13110,
  "endpointsScanned": 508,
  "nginxFound": 6,
  "percentageComplete": 100,
  "request": {
    "cidr": "192.0.2.0/24",
    "hostDiscovery": "icmp",
    "portRanges": [
      "80",
      "443"
    ]
  },
  "serversFound": 6,
  "status": "complete"
}
```

To get the scanned servers, send a GET request to the Servers endpoint:

```shell
curl -X GET "https://<NGINX-INSTANCE-MANAGER-FQDN>/api/v1/servers" -H  "accept: application/json" -H 'Authorization: Bearer <access token>'
```

The result looks similar to the following:

<details open>

  <summary>Scan JSON response</summary>

```json
{
  "items": [
    {
      "certs": [],
      "createTime": "2021-12-01T19:00:27.514Z",
      "cves": [
        {
          "advisory": "http://mailman.nginx.org/pipermail/nginx-announce/2021/000300.html",
          "description": "1-byte memory overwrite in resolver",
          "id": "2021-23017",
          "severity": "medium"
        }
      ],
      "links": [],
      "network": [
        {
          "ip": "192.168.56.2",
          "port": 80
        }
      ],
      "serverApplication": "nginx",
      "updateTime": "2021-12-01T19:00:27.514Z",
      "vendor": "Ubuntu",
      "version": "1.18.0"
    },
    {
      "certs": [],
      "createTime": "2021-12-01T19:00:27.514Z",
      "cves": [
        {
          "advisory": "http://mailman.nginx.org/pipermail/nginx-announce/2021/000300.html",
          "description": "1-byte memory overwrite in resolver",
          "id": "2021-23017",
          "severity": "medium"
        }
      ],
      "links": [],
      "network": [
        {
          "ip": "192.168.56.1",
          "port": 80
        }
      ],
      "serverApplication": "nginx",
      "updateTime": "2021-12-01T19:00:27.514Z",
      "vendor": "Ubuntu",
      "version": "1.18.0"
    },
    {
      "certs": [],
      "createTime": "2021-12-01T19:00:27.515Z",
      "cves": [
        {
          "advisory": "http://mailman.nginx.org/pipermail/nginx-announce/2021/000300.html",
          "description": "1-byte memory overwrite in resolver",
          "id": "2021-23017",
          "severity": "medium"
        }
      ],
      "links": [],
      "network": [
        {
          "ip": "192.168.56.2",
          "port": 443
        }
      ],
      "serverApplication": "nginx",
      "updateTime": "2021-12-01T19:00:27.515Z",
      "vendor": "Ubuntu",
      "version": "1.18.0"
    },
    {
      "certs": [
        {
          "endpoint": {
            "ip": "192.168.56.1",
            "port": 443
          },
          "metadata": {
            "authorityKeyIdentifier": "",
            "commonName": "manager-server",
            "expired": false,
            "expiry": 3161225998,
            "issuer": "C=US, ST=Washington, L=Seattle,  Inc., O=F5\\, OU=Controller, CN=apigw-svc",
            "publicKeyType": "RSA (2048 bit)",
            "serialNumber": "290091060211653667347751276868955784795456843516",
            "signatureAlgorithm": "SHA256-RSA",
            "subject": "C=US, ST=Washington, L=Seattle,  Inc., O=F5\\, OU=Controller, CN=manager-server",
            "subjectAlternativeName": "manager-server",
            "subjectKeyIdentifier": "",
            "thumbprint": "E0:B3:53:81:59:28:B6:C5:88:41:11:8D:B3:E2:B1:C8:D4:32:C1:6B:46:8D:B4:45:37:75:2E:9B:29:C2:A1:70",
            "thumbprintAlgorithm": "SHA-256",
            "validFrom": "2021-11-20T06:48:59Z",
            "validTo": "2122-02-04T06:48:59Z",
            "version": 3
          }
        }
      ],
      "createTime": "2021-12-01T19:00:27.516Z",
      "links": [],
      "network": [
        {
          "ip": "192.168.56.1",
          "port": 443
        }
      ],
      "serverApplication": "nginx",
      "updateTime": "2021-12-01T19:00:27.516Z"
    },
    {
      "certs": [
        {
          "endpoint": {
            "ip": "192.168.56.3",
            "port": 443
          },
          "metadata": {
            "authorityKeyIdentifier": "",
            "commonName": "manager-server",
            "expired": false,
            "expiry": 3161225998,
            "issuer": "C=US, ST=Washington, L=Seattle,  Inc., O=F5\\, OU=Controller, CN=apigw-svc",
            "publicKeyType": "RSA (2048 bit)",
            "serialNumber": "290091060211653667347751276868955784795456843516",
            "signatureAlgorithm": "SHA256-RSA",
            "subject": "C=US, ST=Washington, L=Seattle,  Inc., O=F5\\, OU=Controller, CN=manager-server",
            "subjectAlternativeName": "manager-server",
            "subjectKeyIdentifier": "",
            "thumbprint": "E0:B3:53:81:59:28:B6:C5:88:41:11:8D:B3:E2:B1:C8:D4:32:C1:6B:46:8D:B4:45:37:75:2E:9B:29:C2:A1:70",
            "thumbprintAlgorithm": "SHA-256",
            "validFrom": "2021-11-20T06:48:59Z",
            "validTo": "2122-02-04T06:48:59Z",
            "version": 3
          }
        }
      ],
      "createTime": "2021-12-01T19:00:27.516Z",
      "links": [],
      "network": [
        {
          "ip": "192.168.56.3",
          "port": 443
        }
      ],
      "serverApplication": "nginx",
      "updateTime": "2021-12-01T19:00:27.516Z"
    },
    {
      "certs": [],
      "createTime": "2021-12-02T00:27:34.507Z",
      "cves": [
        {
          "advisory": "http://mailman.nginx.org/pipermail/nginx-announce/2021/000300.html",
          "description": "1-byte memory overwrite in resolver",
          "id": "2021-23017",
          "severity": "medium"
        }
      ],
      "links": [],
      "network": [
        {
          "ip": "192.168.56.3",
          "port": 80
        }
      ],
      "serverApplication": "nginx",
      "updateTime": "2021-12-02T00:27:34.507Z",
      "vendor": "Ubuntu",
      "version": "1.18.0"
    }
  ]
}
```

</details>

---

## Troubleshooting

### Scan reports NGINX versions as "undefined" when NGINX App Protect is enabled

#### Description

- When [scanning for NGINX instances]({{< ref "/nim/nginx-instances/scan-instances.md" >}}), the NGINX version is reported as `undefined` when NGINX App Protect is installed.

#### Resolution

- This behavior is **by design**. As a security precaution when NGINX App Protect is installed, the NGINX server does not report its version in any HTTP headers. The **NGINX Plus** and **Instances** pages in the web interface will continue to report the NGINX and NGINX App Protect versions.
