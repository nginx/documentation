---
docs: "DOCS-1512"
---

{{< note >}}
Never upload your NGINX App Protect WAF v5 images to a public container registry such as Docker Hub. Doing so violates your license agreement.
{{< /note >}}

To build the image, execute the following command in the directory containing the `nginx-repo.crt`, `nginx-repo.key`, and `Dockerfile`. Here, `nginx-app-protect-5` is an example image tag.


```shell
sudo docker build --no-cache --platform linux/amd64 \
  --secret id=nginx-crt,src=nginx-repo.crt \
  --secret id=nginx-key,src=nginx-repo.key \
  -t nginx-app-protect-5 .
```
