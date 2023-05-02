---
title: "Certificates"
date: 2021-06-09T11:52:09-07:00
draft: false
description: "NGINX Instance Manager Certificate Scanning Documentation"
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
docs: "DOCS-630"
---

{{< include "nim/previous-versions/old-version-warning.md" >}}

{{%heading "overview"%}}

This document explains how to scan for expired certificates with NGINX Instance Manager.

# {{%heading "certificate-scanning"%}}

## How it works {#cert-scan}

You can use NGINX Instance Manager to scan for expired certificates in your environment. We will pull back the certificate information from any TLS server and present the expiration dates to you. This can be done through an API call also but is shown in the UI below.

{{<note>}}
The certificate scan looks at the default listener on the IP address and port you specify. Servers using strict SNI for certificates will not show up unless they are the default.

Managed instances will show certificate information based on the NGINX configuration. This includes strict SNI and information that may not show up in the scan.
{{</note>}}

### Limitations {#cert-scan-limit}

Some web servers and services use strict SNI rules to only present certificates if the domain name is exact. We do not use an agent and cannot guess that, so we can't find servers that don't respond to the IP address that's used. If the server has a mix of certificates, the renewal is likely similar, and the tool will give you value.

## Updating Certificates {#updating-certs}

Updating certificates and keys can be done through the API or the web interface. It is important to note that we do not store the private keys and do not have a GET that provides them.

To update these files in the web interface, open the configuration editor for the instance and select the **Cert Management** icon.

Enter the file path and paste in the contents of the certificate or key and publish the file.

This will push the certificate or key to the remote system.

## Next Steps {#next-steps}

- Explore the API for more advanced uploads
- Build your own workflow using the certificate scanner and the certificate upload function
