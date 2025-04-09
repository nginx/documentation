---
description: ''
docs: DOCS-1397
title: Authentication
toc: true
weight: 10
type:
- how-to
---

In this guide, we'll show you how to authenticate API requests with F5 Distributed Cloud and the F5 NGINX One Console. There are two options for authentication: API Token or API Certificate. Both methods ensure secure access to your data.

## Getting ready

Before you begin, make sure you have either an API Token or API Certificate for authentication. You can get these from the F5 Distributed Console. Visit the following link for instructions:

- [F5 Distributed Cloud User Guide: Managing User Credentials](https://docs.cloud.f5.com/docs/how-to/user-mgmt/credentials)

## Authentication methods

You can authenticate API requests in two ways: using an API Token or an API Certificate. Below are examples of how to do this with curl, but you can also use other tools like Postman.

{{<see-also>}}
For definitions of terms such as _'tenant'_ and _'namespace'_ used in the following examples, refer to the [NGINX One Glossary]({{<ref "/nginx-one/glossary.md" >}}).
{{</see-also>}}

<br>

1. **API Token Authentication**: An API token grants a user access to the NGINX One REST API. The user's role determines the permissions associated with the API token. Include the token in the Authorization request header.

   Here's how to use an API token to authenticate a request to the F5 Distributed Cloud API. This example request lists tenant namespaces for organization plans:

   ```shell
   curl https://<tenant>.console.ves.volterra.io/api/web/namespaces \
   -H "Authorization: APIToken <token-value>"
   ```

   - `<tenant>`: Your tenant name for organization plans.
   - `<token-value>` Your API Token.

2. **API Certificate Authentication**: Include the client certificate and password in the request. For organization plans:

   ```shell
   curl https://<tenant>.console.ves.volterra.io/api/web/namespaces --cert-type P12 \
   --cert <api-creds>:<password>
   ```

   - `<tenant>`: Your tenant name for organization plans.
   - `<api-creds>`: The path to your certificate file. It's best to use the full path of the certificate.
   - `<password>` Your certificate password.

## Constructing a request

NGINX One API requests should follow this URL format:

```text
https://<tenant>.console.ves.volterra.io/api/nginx/one/namespaces/{namespace}/{kind}
```

- `<tenant>`: Your tenant name for organization plans.
- `{namespace}`: The namespace your object belongs to.
- `{kind}`: The type of object you're dealing with.

For instance, to list all NGINX One 'data-plane-key' objects in the 'default' namespace, use:

```shell
curl https://<tenant>.console.ves.volterra.io/api/nginx/one/namespaces/default/data-plane-keys \
-H "Authorization: APIToken <token-value>"
```

## Further reading

- [NGINX One API Reference]({{< ref "/nginx-one/api/api-reference-guide.md" >}})
- [F5 Distributed Cloud API Documentation](https://docs.cloud.f5.com/docs/api)
