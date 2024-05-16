---
docs: "DOCS-1538"
---

Apreload is a new configuration tool where the NGINX App Protect WAF can be configured without having to reload NGINX if only the App Protect configuration is changed and the `nginx.conf` file remains unchanged. Apreload does not affect the existing NGINX reload process and it functions in the same manner as before.

#### Some Conditions Required for Apreload to Work:

- For apreload to work, NGINX must be started first.
- Apreload may be used if the App Protect configuration (policies, log configuration files, global settings etc) have been modified, but the NGINX configuration hasn't changed.<br>

    Whenever `nginx.conf` file or any of its included files are modified, nginx reload must be used, rather than apreload. This will also update any changes in the App Protect configuration (policies, logging profiles, global settings). This applies also if only the App Protect directives have been modified in the `nginx.conf` file.
- Apreload should be executed with the same user that executes NGINX to avoid any access error.
- Apreload calls for changes in the content of the policy, with the exception of the name of the policy.<br>