---
title: "Authentication"
date: 2023-12-07T13:12:49-08:00
# Change draft status to false to publish doc.
draft: false
# Description
# Add a short description (150 chars) for the doc. Include keywords for SEO. 
# The description text appears in search results and at the top of the doc.
description: ""
# Assign weights in increments of 100
weight: 10
toc: true
tags: [ "docs" ]
# Create a new entry in the Jira DOCS Catalog and add the ticket ID (DOCS-<number>) below
docs: "DOCS-000"
# Taxonomies
# These are pre-populated with all available terms for your convenience.
# Remove all terms that do not apply.
categories: ["installation", "platform management", "load balancing", "api management", "service mesh", "security", "analytics"]
doctypes: ["task"]
journeys: ["researching", "getting started", "using", "renewing", "self service"]
personas: ["devops", "netops", "secops", "support"]
versions: []
authors: []

---

{{<custom-styles>}}

In this guide, we'll show you how to authenticate API requests with F5 Distributed Cloud. There are two options for authentication: API Token or API Certificate. Both methods ensure secure access to your data.

## Getting Ready

Before you begin, make sure you have either an API Token or API Certificate for authentication. You can get these from the F5 Distributed Cloud Console. Visit the following link for instructions:

- [F5 Distributed Cloud User Guide: Managing User Credentials](https://docs.cloud.f5.com/docs/how-to/user-mgmt/credentials)

## Authentication Methods

You can authenticate API requests in two ways: using an API Token or an API Certificate. Below are examples of how to do this with curl, but you can also use other tools like Postman.

{{<see-also>}}
For definitions of terms such as _'tenant'_ and _'namespace'_ used in the following examples, refer to the [NGINX One Glossary]({{<relref "/nginx-one/reference/glossary.md" >}}).
{{</see-also>}}

<br>

1. **API Token Authentication**: Include the token in the Authorization request header. Note that the permissions will be the same as the user who created the token.

   Here's how to list tenant namespaces for organization plans:

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

## Constructing a Request

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


## Further Reading

- [NGINX One API Reference]({{< relref "nginx-one/reference/api/nginx-one-api-reference.md" >}})
- [F5 Distributed Cloud API Documentation](https://docs.cloud.f5.com/docs/api)