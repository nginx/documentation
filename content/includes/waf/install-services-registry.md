---
nd-product: F5WAFN
nd-files:
- content/waf/install/docker.md
- content/waf/install/kubernetes.md
---

Docker registry credentials are needed to access private-registry.nginx.com

Create a directory and copy your certificate and key to this directory:

```shell
mkdir -p /etc/docker/certs.d/private-registry.nginx.com
cp <path-to-your-nginx-repo.crt> /etc/docker/certs.d/private-registry.nginx.com/client.cert
cp <path-to-your-nginx-repo.key> /etc/docker/certs.d/private-registry.nginx.com/client.key
```