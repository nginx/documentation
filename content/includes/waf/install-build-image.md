---
nd-product: F5WAFN
nd-files:
- content/waf/install/docker.md
---

Your folder should contain the following files:

- _nginx-repo.crt_
- _nginx-repo.key_
- _license.jwt_ (Only necessary when using NGINX Plus)
- _nginx.conf_
- _entrypoint.sh_
- _Dockerfile_
- _custom_log_format.json_ (Optional)

To build an image for NGINX Plus, use the following command, replacing `<your-image-name>` as appropriate:

```shell
sudo docker build --no-cache --platform linux/amd64 --secret id=nginx-crt,src=nginx-repo.crt --secret id=nginx-key,src=nginx-repo.key --secret id=license-jwt,src=license.jwt -t <your-image-name> .
```

A RHEL-based system would use the following command instead:

```shell
podman build --no-cache --secret id=nginx-crt,src=nginx-repo.crt --secret id=nginx-key,src=nginx-repo.key --secret id=license-jwt,src=license.jwt -t <your-image-name> .
```
To build an image for NGINX Open Source, use the following command, replacing `<your-image-name>` as appropriate:

```shell
sudo docker build --no-cache --platform linux/amd64 --secret id=nginx-crt,src=nginx-repo.crt --secret id=nginx-key,src=nginx-repo.key -t <your-image-name> .
```

A RHEL-based system would use the following command instead:

```shell
podman build --no-cache --secret id=nginx-crt,src=nginx-repo.crt --secret id=nginx-key,src=nginx-repo.key -t <your-image-name> .
```

{{< call-out "note" >}}

The `--no-cache` option is used to ensure the image is built from scratch, installing the latest versions of NGINX Plus and F5 WAF for NGINX.

{{< /call-out >}}

Verify that your image has been created using the `docker images` command:

```shell
docker images <your-image-name>
```

Create a container based on this image, replacing <your-container-name> as appropriate:

```shell
docker run --name <your-container-name> -p 80:80 -d <your-image-name>
```

Verify the new container is running using the `docker ps` command:

```shell
docker ps
```
