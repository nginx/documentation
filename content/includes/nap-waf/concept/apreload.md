---
nd-docs: DOCS-000
---

apreload is a tool that can update that can update the F5 WAF for NGINX configuration without having to reload NGINX if only the App Protect configuration is changed and the `nginx.conf` file remains unchanged. apreload does not affect the existing NGINX reload process and it functions in the same manner as before.

#### Some Conditions Required for apreload to Work:

- For apreload to work, NGINX must be started first.
- apreload may be used if the App Protect configuration (policies, log configuration files, global settings etc) have been modified, but the NGINX configuration hasn't changed.<br>

    Whenever `nginx.conf` file or any of its included files are modified, nginx reload must be used, rather than apreload. This will also update any changes in the App Protect configuration (policies, logging profiles, global settings). This applies also if only the App Protect directives have been modified in the `nginx.conf` file.
- apreload should be executed with the same user that executes NGINX to avoid any access error.
- apreload handles any changes in the content of the policy, with the exception of the name of the policy.<br>