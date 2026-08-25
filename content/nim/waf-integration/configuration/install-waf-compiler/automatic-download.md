---
title: Automatically update the WAF compiler
description: Enable F5 NGINX Instance Manager to automatically download and install new WAF compiler versions when needed.
toc: true
weight: 300
f5-content-type: how-to
f5-product: NGINX Instance Manager
f5-summary: >
  Enable F5 NGINX Instance Manager to automatically download and install new WAF compiler versions as needed.
  Automatic updates require uploading an F5 WAF for NGINX certificate and key so NGINX Instance Manager can authenticate with the NGINX package repository.
---

After you manually [install at least one version of the F5 WAF for NGINX compiler]({{< ref "/nim/waf-integration/configuration/install-waf-compiler/install.md" >}}), F5 NGINX Instance Manager can automatically download and install newer versions as needed.

Automatic updates occur when:

- A managed instance is upgraded to a newer version of F5 WAF for NGINX.  
- You add a new instance running a different version of F5 WAF for NGINX.

To enable this feature, upload your F5 WAF for NGINX certificate and key to NGINX Instance Manager. This lets NGINX Instance Manager securely connect to the NGINX package repository and download the required compiler files.  

You only need to upload the certificate and key once.

## Upload the F5 WAF for NGINX certificate and key

{{< include "/nim/waf/upload-cert-and-key.md" >}}

---

## Troubleshooting automatic updates

If NGINX Instance Manager can’t connect to the repository, or the certificate is missing or invalid, you’ll see an error like:

```text
missing the specific compiler, please install it and try again.
```

This means the certificate or key might be missing, invalid, or expired, or that NGINX Instance Manager can’t reach the NGINX repository.

Check for related errors in the log file:

```text
/var/log/nms/nms.log
```

If you see a message like this, the certificate or key is likely invalid or expired:

```text
error when creating the nginx repo retriever - NGINX repo certificates not found
```

{{<call-out class="warning" title="Known issue for auto-downloaded nms-nap-compiler-v5.690.0" >}}If you see following error messages in the UI: 
```text
<instance_name>: failed building config payload: policy compilation failed for deployment <deployment_id> due to integrations service error: compiler controller error: exit status 1
```

<b>AND</b></br>

If the log contains any of the following error messages:</br>

for Debian or Ubuntu-based systems:
```text
/usr/bin/perl: symbol lookup error: /opt/nms-nap-compiler/app_protect-5.690.0/bin/../lib/perl/auto/F5/PatternMatching/PatternMatching.so: undefined symbol: _ZN3re23RE2C1ESt17basic_string_viewIcSt11char_traitsIcEERKNS0_7OptionsE
```

<b>OR</b></br>

for RHEL-based systems: 
```text
Can't load '/opt/nms-nap-compiler/app_protect-5.690.0/bin/../lib/perl/auto/F5/PatternMatching/PatternMatching.so' for module F5::PatternMatching: libre2.so.11: cannot open shared object file: No such file or directory at /usr/lib64/perl5/DynaLoader.pm
```

<b>Workaround</b>: Execute below command
   ```shell
   sudo bash -c '
   cd /opt/nms-nap-compiler/app_protect-5.690.0/lib && \
   ln -sfn libre2.so.11.0.0 libre2.so.11 && \
   ln -sfn libprotobuf.so.3.21.12.0 libprotobuf.so.32 && \
   ln -sfn libprotobuf.so.32 libprotobuf.so
   '
   ```
{{</call-out>}}

If needed, you can [install the WAF compiler manually]({{< ref "/nim/waf-integration/configuration/install-waf-compiler/install.md" >}}).
