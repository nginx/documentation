---
docs: "DOCS-1540"
---

Apreload will not take into effect these Policy modifications:

- New user defined HTTP headers, refer to [User-defined HTTP Headers](#user-defined-http-headers) section. Note that modifications to existing user-defined headers will take effect in apreload.
- XFF trust modifications, refer to [XFF Headers and Trust](#xff-headers-and-trust) section for more details. <br>

If you want to apply any of the above modifications, reload NGINX rather invoking apreload, even if NGINX configuration has not been modified.