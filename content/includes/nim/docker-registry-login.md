---
docs: DOCS-000
---

To configure Docker to communicate with the NGINX container registry located at `private-registry.nginx.com`, follow these steps:

1. Download your NGINX Instance Manager subscription's JSON Web Token and license from [MyF5](https://my.f5.com/manage/s/subscriptions).
   - Log in to the [MyF5](https://my.f5.com/manage/s/subscriptions) customer portal.
   - Go to **My Products and Plans > Subscriptions**.
   - Select the product subscription.
   - Download the JSON Web Token (JWT) and license files.
1. Open the JWT file you downloaded from [MyF5](https://my.f5.com/manage/s/subscriptions) and copy its contents.
1. Log in to the Docker registry using the contents of the JWT file:

```shell
docker login private-registry.nginx.com --username=<JWT_CONTENTS> --password=none
```

{{< note >}}
Ensure there are no extra characters or whitespaces when copying the contents of the JWT token: they can invalidate the token and cause 401 errors during authentication.
{{< /note >}}