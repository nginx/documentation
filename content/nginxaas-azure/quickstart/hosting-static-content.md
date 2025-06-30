---
title: Hosting static content
weight: 200
toc: true
nd-docs: DOCS-1344
url: /nginxaas/azure/quickstart/hosting-static-content/
type:
- how-to
---

F5 NGINX as a Service for Azure (NGINXaaS) supports hosting static content which allows users to serve static websites from their deployment.

## Uploading static files as a tarball

Follow the steps listed below to upload static content and relevant NGINX configuration using `tar`:

1. Create an `nginx.conf` to configure your deployment to serve static content. The following is an example NGINX configuration:

```nginx
http {
	server {
		listen 80;
		location / {
			root /srv;
			index index.html;
		}
	}
}
```

2. Store your static files alongside the NGINX configuration.

The following shows the structure of a directory containing an NGINX configuration and an `index.html` file that we will be served from the deployment.

```bash
test-static-files $ tree .
.
├── nginx.conf
└── srv
    └── index.html

2 directories, 2 files
```

{{<note>}}`index.html` is placed under the `srv` directory. When using `tar` to upload static content, the static content has to be placed under one of the allowed paths listed in the [NGINX Filesystem Restrictions table]({{< ref "/nginxaas-azure/getting-started/nginx-configuration/overview/#nginx-filesystem-restrictions" >}}).{{</note>}}

3. Create the tarball.

```bash
test-static-files $ tar -cvzf <path to store tarball>/test.tar.gz *
```

4. Upload the tarball following instructions listed in the [NGINX configuration]({{< ref "/nginxaas-azure/getting-started/nginx-configuration/nginx-configuration-portal.md#upload-gzip-nginx-configuration" >}}) documentation.

5. After uploading the configuration, you should see the following files in your deployment:
   - `nginx.conf`
   - `srv/index.html`

6. Browse to the deployment IP address, and you will see `index.html` being served from the deployment.

## Uploading static files directly to the deployment

You can also upload static files directly to the deployment. See [Adding NGINX Configuration]({{< ref "/nginxaas-azure/getting-started/nginx-configuration/nginx-configuration-portal.md#add-nginx-configuration" >}}) to upload individual files to your deployment. Refer to the [NGINX Filesystem Restrictions table]({{< ref "/nginxaas-azure/getting-started/nginx-configuration/overview/#nginx-filesystem-restrictions" >}}) to see where files can be written to and read from.

## Limitations

NGINX Configuration payload larger than 3 MB is not supported.
