---
---

{{< call-out "note" >}}

The commands in the rest of this document should be run in the same directory as your **license.jwt** file.

JWTs are sensitive information and should be stored securely. Delete them after use to prevent unauthorized access.

{{< /call-out >}}

Once you have obtained your license JWT, create a Kubernetes secret using `kubectl create`:

```shell
kubectl create secret generic nplus-license --from-file license.jwt
```

{{< details summary="Example output" >}}

```text
secret/nplus-license created
```

{{< /details >}}

Then create another Kubernetes secret to allow interactions with the F5 registry:

```shell
kubectl create secret docker-registry regcred \
  --docker-server=private-registry.nginx.com \
  --docker-username=$(cat license.jwt) \
  --docker-password=none
```

{{< details summary="Example output" >}}

```text
secret/regcred created
```

{{< /details >}}