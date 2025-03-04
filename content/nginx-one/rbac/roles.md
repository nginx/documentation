---
title: "Default roles"
weight: 500
toc: true
type: reference
product: NGINX One
docs: DOCS-000
---

## Default roles

We provide three default **[roles](https://docs.cloud.f5.com/docs-v2/administration/how-tos/user-mgmt/roles)** that can be used for providing various access levels to the NGINX One Console. These roles will be automatically updated as new features are added to the NGINX One Console. Default roles can be scoped to specific namespaces.

### Admin

The Admin role, identified as <code>f5xc-nginx-one-admin</code>, provides full read and write access to all endpoints and features within the NGINX One Console.

### User

Our standard User role, listed as <code>f5xc-nginx-one-user</code> in the role list, provides read and write access to all endpoints and features, save for those considered to be administrator level. An example of an administrator level feature would be **[Instance Settings](https://docs.nginx.com/nginx-one/how-to/nginx-configs/clean-up-unavailable-instances/)** where unavailable instance clean up logic is set.

### Monitor

Our read only or Monitor role, <code>f5xc-nginx-one-monitor</code>, grants read only access to all non-administrator features and endpoints within the NGINX One Console.

