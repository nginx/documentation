---
nd-docs: "DOCS-1508"
---

Configure Docker to interact with the F5 Container Registry at `private-registry.nginx.com`:

```shell
sudo mkdir -p /etc/docker/certs.d/private-registry.nginx.com
sudo cp <path-to-your-nginx-repo.crt> /etc/docker/certs.d/private-registry.nginx.com/client.cert
sudo cp <path-to-your-nginx-repo.key> /etc/docker/certs.d/private-registry.nginx.com/client.key
```

{{< call-out "note" >}}
Please note that the file extension for the certificate file has changed from `.crt` to `.cert`
{{< /call-out >}}