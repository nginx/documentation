---
title: Automatically update the WAF compiler
description: Enable NGINX Instance Manager to automatically download and install new WAF compiler versions when needed.
toc: true
weight: 300
nd-content-type: how-to
nd-product: NIM
nd-docs:
---

After you manually [install at least one version of the F5 WAF for NGINX compiler]({{< ref "/nim/waf-integration/configuration/install-waf-compiler/install.md" >}}), NGINX Instance Manager can automatically download and install newer versions as needed.

Automatic updates occur when:

- A managed instance is upgraded to a newer version of F5 WAF for NGINX.  
- You add a new instance running a different version of F5 WAF for NGINX.

To enable this feature, upload your F5 WAF for NGINX certificate and key to NGINX Instance Manager. This lets Instance Manager securely connect to the NGINX package repository and download the required compiler files.  

You only need to upload the certificate and key once.

## Upload the F5 WAF for NGINX certificate and key

{{< include "/nim/waf/upload-cert-and-key.md" >}}

---

## Troubleshooting automatic updates

If NGINX Instance Manager can’t connect to the repository, or the certificate is missing or invalid, you’ll see an error like:

```text
missing the specific compiler, please install it and try again.
```

This means the certificate or key might be missing, invalid, or expired, or that Instance Manager can’t reach the NGINX repository.

Check for related errors in the log file:

```text
/var/log/nms/nms.log
```

If you see a message like this, the certificate or key is likely invalid or expired:

```text
error when creating the nginx repo retriever - NGINX repo certificates not found
```

If needed, you can [install the WAF compiler manually]({{< ref "/nim/waf-integration/configuration/install-waf-compiler/install.md" >}}).
