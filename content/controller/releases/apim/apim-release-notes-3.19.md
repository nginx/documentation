---
description: These release notes contain information about new features, improvements,
  known issues, and bug fixes in the NGINX Controller API Management Module.
docs: DOCS-369
title: Release Notes 3.19.0
toc: true
weight: 97
type:
- reference
---

{{< include "controller/apim-rn-preamble.md" >}}

&nbsp;

---

August 9, 2021

## Upgrade Considerations

Take note of the following considerations when upgrading to this version of the NGINX Controller API Management Module:

- After upgrading NGINX Controller, make sure to upgrade the NGINX Controller Agent too.

- If you're upgrading NGINX Controller on a multi-node cluster, run the `update.sh` script on each node individually -- the order in which you update the nodes doesn't matter.

  {{< warning >}}Never update the control nodes in parallel. Doing so may result in race conditions for certain jobs, such as database migrations, and may cause the cluster to become unavailable.{{< /warning >}}

## What's New

- **NGINX Controller API Management Advanced Security**

  You can use the [App Security add-on]({{< relref "/controller/app-delivery/security/concepts/_index.md" >}})for NGINX Controller APIM to enable Web Application Firewall (WAF) capabilities to protect your APIs. WAF lets you flag or block suspicious requests or attacks.

- **Support added for multiple `API key` identity providers on a component**

  Now you can add multiple identity providers of type `API key` on a component. This will allow you to assign keys with better granularity.

- **API Keys can be imported from a CSV file**

  API Keys can be imported from a CSV file or pasted in as a comma-separated list.

## Resolved Issues

This release includes the following fixes. To locate the details for an issue when it was first reported, search the NGINX Docs for the issue ID.

- Authentication policies are not yet supported for SOAP-REST proxy (26211)

- Instructions for restoring external config database may not restore published APIs (26280)

- Improved messaging when WSDL import fails (26630)

- WSDLs without "types" section can now be imported (26655)

## Known Issues

The following issues are known to be present in this release. Look for updates to these issues in future release notes.

- **Cannot use multiple listenIPs and a wildcard IP on the same port (26466)**

  If you set more than one listenIP and a wildcard IP (null listenIP) to use the same port on the same NGINX Plus instance, reuseport will apply to all of the IP:port pairs on the listen directive in the nginx.conf - except the first - as well as to the wildcard IP. An example config is below:

  ```bash
  server {
    listen ip1:port;
    listen ip2:port reuseport;
    listen ip3:port reuseport;
  }
  server {
    listen port reuseport;  <-- wildcard IP
  }
  ```

  This will cause all the traffic passed to the IP:port pairs that are using reuseport to be forwarded to the server block with the wildcard IP on the same port, because of the NGINX server match rule. The first IP:port pair is not affected.

  **Workaround:**

  To avoid this issue, use a unique port for each HTTP uri when both listenIP and wildcard IP are being used on the same instance.

## Supported NGINX Plus Versions

NGINX Controller works with the following NGINX Plus versions:

- NGINX Plus R24
- NGINX Plus R23
- NGINX Plus R22
- NGINX Plus R21
- NGINX Plus R20
- NGINX Plus R19
