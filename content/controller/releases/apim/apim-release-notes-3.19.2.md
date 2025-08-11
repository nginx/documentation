---
description: These release notes contain information about new features, improvements,
  known issues, and bug fixes in the NGINX Controller API Management Module.
nd-docs: DOCS-368
title: Release Notes 3.19.2
toc: true
weight: 95
type:
- reference
---

{{< include "controller/apim-rn-preamble.md" >}}

&nbsp;

---

October 19, 2021

## Upgrade Considerations

Take note of the following considerations when upgrading to this version of the NGINX Controller API Management Module:

- After upgrading NGINX Controller, make sure to upgrade the NGINX Controller Agent too.

- If you're upgrading NGINX Controller on a multi-node cluster, run the `update.sh` script on each node individually -- the order in which you update the nodes doesn't matter.

  {{< call-out "warning" >}}Never update the control nodes in parallel. Doing so may result in race conditions for certain jobs, such as database migrations, and may cause the cluster to become unavailable.{{< /call-out >}}

## What's New

- Adds support for [NGINX Plus R25](https://docs.nginx.com/nginx/releases/#nginxplusrelease-25-r25)
- Adds support for [NAP 3.6](https://docs.nginx.com/nginx-app-protect/releases/#release-36)


## Known Issues

The following issues are known to be present in this release. Look for updates to these issues in future release notes.

- **Managed instances go offline or become unresponsive after registering an NGINX Plus R25 instance with NGINX Controller (33356)**

  After an NGINX Plus R25 instance is registered with NGINX Controller, managed instances may appear to go offline or become unresponsive. An error similar to the following is written to the pod/dataplane-manager log:

  ```shell
  panic: runtime error: invalid memory address or nil pointer dereference
  [signal SIGSEGV: segmentation violation code=0x1 addr=0x0 pc=0xd2ee26]
  ```

  **Workaround:**

  Upgrade to NGINX APIM 3.19.3 or later, or NGINX ADC 3.22 or later

- **Error may be displayed that bd_agent was not found when enabling WAF  (29206)**

  After installing NGINX App Protect 3.6, the following error message my be displayed when enabling WAF on a component:

  *Error: The following module processes were expected but not found: [bd_agent]*

  **Workaround:**

  Manually start the bd_agent process on the NAP module using this command: 
 ```bash {linenos=false,hl_lines=[1]}
 /bin/su -s /bin/bash -c '/opt/app_protect/bin/bd_agent &' nginx.
 ```

  Then restart the NGINX service.

- **NGINX service fails to start if SELinux enforcing mode is enabled after NGINX App Protect is deployed (16540)**

  Setting SElinux to enforcing mode on an NGINX App Protect Instance may cause the NGINX service to fail to start after the Instance is rebooted.

  **Workaround:**

  Enable SElinux enforcing mode before deploying NGINX App Protect.

## Supported NGINX Plus Versions

This version of NGINX Controller works with the following NGINX Plus versions:

- NGINX Plus R25
- NGINX Plus R24
- NGINX Plus R23
- NGINX Plus R22
- NGINX Plus R21
- NGINX Plus R20
- NGINX Plus R19
