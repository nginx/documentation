---
f5-product: F5 WAF for NGINX
f5-files:
- content/waf/install/docker.md
- content/waf/install/kubernetes.md
---

You will need Docker registry credentials to access private-registry.nginx.com.

Create a directory and copy your certificate and key to this directory:

```shell
mkdir -p /etc/docker/certs.d/private-registry.nginx.com
cp <PATH/TO/NGINX_REPO.CRT> /etc/docker/certs.d/private-registry.nginx.com/client.cert
cp <PATH/TO/NGINX_REPO.KEY> /etc/docker/certs.d/private-registry.nginx.com/client.key
```

Replace `<PATH/TO/NGINX_REPO.CRT>` with the path to your `nginx-repo.crt` client certificate and `<PATH/TO/NGINX_REPO.KEY>` with the path to your `nginx-repo.key` client key.