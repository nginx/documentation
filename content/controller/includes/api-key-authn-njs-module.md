When using API keys for authentication, the API key is written to the NGINX Plus config as cryptographically-protected hashes. 

To use API key authentication for any element of NGINX Controller, you must install the `njs` module on all NGINX Plus instances.

If you do not install the `njs` module and use API key authentication, whether for API Management or elsewhere, the system may experience errors that are not reported in the user interface.

> See the [NGINX Admin Guide](https://docs.nginx.com/nginx/admin-guide/dynamic-modules/nginscript/) for `njs` installation instructions.

<!-- Do not remove. Keep this code at the bottom of the include -->
<!-- DOCS-572 -->