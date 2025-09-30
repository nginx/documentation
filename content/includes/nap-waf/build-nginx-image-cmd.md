---
nd-docs: "DOCS-1512"
---

{{< call-out "note" >}}
Never upload your F5 WAF for NGINX v5 images to a public container registry such as Docker Hub. Doing so violates your license agreement.
{{< /call-out >}}

To build the image, execute the following command in the directory containing the `nginx-repo.crt`, `nginx-repo.key`, and `Dockerfile`. Here, `nginx-app-protect-5` is an example image tag.


```shell
sudo docker build --no-cache --platform linux/amd64 \
  --secret id=nginx-crt,src=nginx-repo.crt \
  --secret id=nginx-key,src=nginx-repo.key \
  -t nginx-app-protect-5 .
```
