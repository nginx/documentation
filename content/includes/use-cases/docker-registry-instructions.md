---
f5-product: Miscellaneous
f5-files:
- content/nginx/admin-guide/installing-nginx/installing-nginx-docker.md
- content/nic/install/images/registry-download.md
---

This step describes how to use Docker to communicate with the F5 Container Registry located at `private-registry.nginx.com`.

{{< call-out class="note" >}}

The steps provided are for Linux. For Mac or Windows, see the [Docker for Mac](https://docs.docker.com/docker-for-mac/#add-client-certificates) or [Docker for Windows](https://docs.docker.com/docker-for-windows/#how-do-i-add-client-certificates) documentation. 

For more details on Docker Engine security, you can refer to the [Docker Engine Security documentation](https://docs.docker.com/engine/security/).

{{< /call-out >}}

{{< tabs name="docker_login" >}}

{{% tab name="JSON Web Token"%}}

Open the JSON Web Token file previously downloaded from [MyF5](https://my.f5.com) customer portal (for example, `nginx-repo-12345abc.jwt`) and copy its contents.

Log in to the Docker registry using the contents of the JSON Web Token file:

```shell
docker login private-registry.nginx.com --username=<OUTPUT_OF_JWT_TOKEN> --password=none
```

Replace `<OUTPUT_OF_JWT_TOKEN>` with the contents of your JWT.

{{% /tab %}}

{{% tab name="SSL" %}}

Create a directory and copy your certificate and key to this directory:

```shell
mkdir -p /etc/docker/certs.d/private-registry.nginx.com
cp <PATH/TO/NGINX_REPO.CRT> /etc/docker/certs.d/private-registry.nginx.com/client.cert
cp <PATH/TO/NGINX_REPO.KEY> /etc/docker/certs.d/private-registry.nginx.com/client.key
```

Replace `<PATH/TO/NGINX_REPO.CRT>` with the path to your `nginx-repo.crt` client certificate and `<PATH/TO/NGINX_REPO.KEY>` with the path to your `nginx-repo.key` client key.

{{% /tab %}}

{{< /tabs >}}
