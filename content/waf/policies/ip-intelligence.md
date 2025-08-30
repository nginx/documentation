---
# We use sentence case and present imperative tone
title: "IP intelligence"
# Weights are assigned in increments of 100: determines sorting order
weight: 400
# Creates a table of contents and sidebar, useful for large documents
toc: true
# Types have a 1:1 relationship with Hugo archetypes, so you shouldn't need to change this
nd-content-type: reference
# Intended for internal catalogue and search, case sensitive:
# Agent, N4Azure, NIC, NIM, NGF, NAP-DOS, NAP-WAF, NGINX One, NGINX+, Solutions, Unit
nd-product: NAP-WAF
---

F5 WAF for NGINX has an IP intelligence feature which allows you to customize enforcement based on the source IP address of a request. This allows you to limit access from specific IP addresses. 

It is _**disabled** by default_, requiring extra steps to enable and configure.

## Enable IP intelligence

### Before you begin

To complete this guide, you will need the following prerequisites:

- The host must have an active internet connection and working DNS
- The host must be able to access `vector.brightcloud.com` over port 443
- The host must be configured properly if connecting through a forward proxy server

A proxy server can be configured in the file `/etc/app_protect/tools/iprepd.cfg`:

```shell
EnableProxy=True 
ProxyHost=5.1.2.4
ProxyPort=8080
ProxyUsername=admin        # Optional
ProxyPassword=admin        # Optional
CACertPath=/etc/ssl/certs/ca-certificates.crt  # Optional`
```

After saving the changes, restart the client to apply the new settings:

```shell
/opt/app_protect/bin/iprepd /etc/app_protect/tools/iprepd.cfg > ipi.log 2>&1 &
```

### Install virtual machine packages

{{< call-out "warning" >}}

This section **only** applies to V4 packages.

{{< /call-out >}}

To enable IP intelligence on a virtual machine or bare metal installation, you must install an extra package. You can install the extra package during or after set-up.

Review the [virtual machine installation instructions]({{< ref "/waf/install/plus/virtual-environment.md" >}}) for information on how to use the package manager for a specific operating system.

| Operating system                    | Package name                  |
| ----------------------------------- | ----------------------------- |
| Alpine Linux                        | _app-protect-ip-intelligence_ |
| Amazon Linux                        | _app-protect-ip-intelligence_ |
| Debian                              | _app-protect-ip-intelligence_ |
| Oracle Linux / RHEL / Rocky Linux 8 | _app-protect-ip-intelligence_ |
| Ubuntu                              | _app-protect-ip-intelligence_ |
| RHEL / Rocky Linux 9                | _app-protect-ip-intelligence_ |

After installing the package, run the client:

```shell
/opt/app_protect/bin/iprepd /etc/app_protect/tools/iprepd.cfg > ipi.log 2>&1 &
```

Then verify the client is populating the database:

```shell
tail -f iprepd.log
```

Once complete, you can now [Configure policies for IP intelligence](#configure-policies-for-ip-intelligence).

### Modify Docker compose file

{{< call-out "warning" >}}

This section **only** applies to V5 packages.

{{< /call-out >}}

IP intelligence has its own Docker container when using a V5 package.

You can add it to the deployment in your Docker Compose file.

First, create the required directory:

```shell
sudo mkdir -p /var/IpRep
```

Then set correct ownership of the directory:

```shell
sudo chown -R 101:101 /var/IpRep
```

Modify the _original docker-compose.yml_ file to include the IP intelligence container, replacing image tags as appropriate:

```
services:
  waf-enforcer:
    container_name: waf-enforcer
    image: waf-enforcer:5.7.0
    environment:
      - ENFORCER_PORT=50000
    ports:
      - "50000:50000"
    volumes:
      - /opt/app_protect/bd_config:/opt/app_protect/bd_config
    networks:
      - waf_network
    restart: always
    depends_on:
      - waf-ip-intelligence

  waf-config-mgr:
    container_name: waf-config-mgr
    image: waf-config-mgr:5.7.0
    volumes:
      - /opt/app_protect/bd_config:/opt/app_protect/bd_config
      - /opt/app_protect/config:/opt/app_protect/config
      - /etc/app_protect/conf:/etc/app_protect/conf
    restart: always
    network_mode: none
    depends_on:
      waf-enforcer:
        condition: service_started

   waf-ip-intelligence:
    container_name: waf-ip-intelligence
    image: waf-ip-intelligence:5.7.0
    volumes:
      - /var/IpRep:/var/IpRep
    networks:
      - waf_network
    restart: always

networks:
  waf_network:
    driver: bridge
```

Once complete, you can now [Configure policies for IP intelligence](#configure-policies-for-ip-intelligence).

## Configure policies for IP intelligence

Once the requirements for IP intelligence have been installed, you can enable it in two sections of your policy:

1. In the violation list, assigning block and alarm values (`"name": "VIOL_MALICIOUS_IP"`)
1. In a new IP intelligence section, defining actions for each category (`"ip-intelligence": {"enabled": true}`)

The following policy shows examples of both, with all IP intelligence categories configure to _block_ and _alarm_:

```json
{
    "policy": {
        "name": "ip_intelligency_policy",
        "template": {
            "name": "POLICY_TEMPLATE_NGINX_BASE"
        },
        "applicationLanguage": "utf-8",
        "caseInsensitive": false,
        "enforcementMode": "blocking",
        "blocking-settings": {
            "violations": [
                {
                    "name": "VIOL_MALICIOUS_IP",
                    "alarm": true,
                    "block": true
                }
            ]
        },
        "ip-intelligence": {
            "enabled": true,
            "ipIntelligenceCategories": [
                {
                    "category": "Anonymous Proxy",
                    "alarm": true,
                    "block": true
                },
                {
                    "category": "BotNets",
                    "alarm": true,
                    "block": true
                },
                {
                    "category": "Cloud-based Services",
                    "alarm": true,
                    "block": true
                },
                {
                    "category": "Denial of Service",
                    "alarm": true,
                    "block": true
                },
                {
                    "category": "Infected Sources",
                    "alarm": true,
                    "block": true
                },
                {
                    "category": "Mobile Threats",
                    "alarm": true,
                    "block": true
                },
                {
                    "category": "Phishing Proxies",
                    "alarm": true,
                    "block": true
                },
                {
                    "category": "Scanners",
                    "alarm": true,
                    "block": true
                },
                {
                    "category": "Spam Sources",
                    "alarm": true,
                    "block": true
                },
                {
                    "category": "Tor Proxies",
                    "alarm": true,
                    "block": true
                },
                {
                    "category": "Web Attacks",
                    "alarm": true,
                    "block": true
                },
                {
                    "category": "Windows Exploits",
                    "alarm": true,
                    "block": true
                }
            ]
        }
    }
}
```

This policy will block  all IP addresses that are part of any threat category (`"block": true`) and add a log entry (`"alarm": true`) for the transaction.

The IP address database is managed by an external provider and is constantly updated (every 1 minute by default). 

The database categorizes IP addresses into one or more threat categories. These are the same categories that can be configured individually in the IP intelligence section:

- Anonymous Proxy
- BotNets
- Cloud-based Services
- Denial of Service
- Infected Sources
- Mobile Threats
- Phishing Proxies
- Scanners
- Spam Sources
- Tor Proxies
- Web Attacks
- Windows Exploits

Since the IP address database is constantly updated, their enforcement may also change. Addresses may be added, removed, or moved from one category to another based on their reported activity.