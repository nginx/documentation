---
nd-docs: DOCS-337
title: Automatically update security packages
description: Enable automatic updates in NGINX Instance Manager to keep F5 WAF for NGINX packages current.
toc: true
weight: 100
nd-content-type: how-to
nd-product: NIMNGR
---

## Upload the F5 WAF for NGINX certificate and key

To enable automatic downloads, NGINX Instance Manager must authenticate with the NGINX repository. Upload the repository certificate and private key provided with your F5 WAF for NGINX subscription. After you upload these files, NGINX Instance Manager can securely download the latest attack signature, bot signature, and threat campaign packages.

{{< include "/nim/waf/upload-cert-and-key.md" >}}

## Enable automatic downloads

NGINX Instance Manager can automatically download the latest attack signatures, bot signatures, and threat campaign versions. To enable automatic downloads:

1. Log in to the NGINX Instance Manager host using SSH.
1. Open the `/etc/nms/nms.conf` file in a text editor.
1. Adjust the `app_protect_security_update` settings as shown in the example below:

   ```yaml
   integrations:
     # enable this for integrations on tcp
     # address: 127.0.0.1:8037
     address: unix:/var/run/nms/integrations.sock
     dqlite:
       addr: 127.0.0.1:7892
     app_protect_security_update:
       # enable this to automatically retrieve the latest attack signatures, bot signatures, and threat campaigns
       enable: true
       # how often, in hours, to check for updates; default is 6
       interval: 6
       # how many updates to download; default is 10, max is 20
       number_of_updates: 10
   ```

1. Save the changes and close the file.
1. {{< include "/nim/waf/restart-nms-integrations.md" >}}

If the F5 WAF for NGINX certificate or key is missing, invalid, or expired, you’ll see an error like this:

```text
error when creating the nginx repo retriever - NGINX repo certificates not found
```

This means NGINX Instance Manager can’t connect to the NGINX repository to retrieve packages. Re-upload a valid certificate and key to resolve the issue.
