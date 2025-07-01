---
nd-docs: "DOCS-1666"
---

1. Download your NGINX Instance Manager subscription's JSON Web Token from MyF5. You can use the same JSON Web Token as NGINX Plus in your MyF5 portal.

   {{< include "licensing-and-reporting/download-jwt-from-myf5.md" >}}

1. Open the JSON Web Token file you downloaded from [MyF5](https://my.f5.com/manage/s/subscriptions) and copy its contents.

   {{<call-out "tip" "Copying the JWT token" "" >}} Make sure there are **no extra characters or spaces** when copying the contents of the JWT token: they can invalidate the token and cause 401 errors during authentication.{{</call-out>}}

2. Log in to the Docker registry using the contents of the JSON Web Token file:

   ```bash
   docker login private-registry.nginx.com --username=<JWT_CONTENTS> --password=none
   ```

