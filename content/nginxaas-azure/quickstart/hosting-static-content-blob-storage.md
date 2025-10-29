---
title: Hosting static content in Azure Blob Storage
weight: 210
toc: true
nd-docs: DOCS-1344
url: /nginxaas/azure/quickstart/hosting-static-content-blob-storage/
type:
- how-to
---

F5 NGINXaaS for Azure (NGINXaaS) can serve static content stored in Azure Blob Storage, allowing you to host large static websites without the configuration payload size limitations of local hosting. This approach also keeps your storage account private by restricting access to your NGINXaaS deployment.

## Prerequisites

- An Azure Storage Account
- An NGINXaaS for Azure deployment
- Static content files to serve

## Configure Azure Blob Storage

### Step 1: Upload static files to the $web container

Place your static files in the `$web` container in your storage account. This is the standard container used for static website hosting in Azure.

### Step 2: Configure network access

1. In your storage account, navigate to **Networking** under **Security + networking**.
2. Under **Public network access**, select **Enable public access from selected virtual networks and IP addresses**.
3. In the **Virtual networks** section, click **Add existing virtual network**.
4. Select the virtual network and subnet where your NGINXaaS deployment is located.
5. Click **Add** to allow your NGINXaaS deployment to connect to the storage account.

{{< call-out "note" >}}This configuration ensures that your storage account is not accessible from the public Internet, only from your NGINXaaS deployment's subnet.{{< /call-out >}}

### Step 3: Enable static website hosting

1. In your storage account, navigate to **Static website** under **Data management**.
2. Enable **Static website**.
3. Set your **Index document name** (e.g., `index.html`).
4. Optionally, set an **Error document path** for 404 errors.
5. Click **Save**.

Note the **Primary endpoint** URL that appears after enabling static website hosting. You'll need this for your NGINX configuration.

## Configure NGINXaaS

Create an NGINX configuration that proxies requests to your Azure Blob Storage static website endpoint:

```nginx
user nginx;
worker_processes auto;
worker_rlimit_nofile 8192;
pid /run/nginx/nginx.pid;

error_log /var/log/nginx/error.log error;

http {
    upstream storage_origin {
        server your-storage-account.z20.web.core.windows.net:443;
        keepalive 32;
    }

    server {
        listen 443 ssl;
        ssl_certificate /etc/nginx/example.cert;
        ssl_certificate_key /etc/nginx/example.key;

        location /static/ {
            proxy_pass https://storage_origin/content/;
            proxy_set_header Host your-storage-account.z20.web.core.windows.net;
            proxy_http_version 1.1;
            proxy_set_header Connection "";
        }
    }
}
```

{{< call-out "important" >}}Replace `your-storage-account` with your actual storage account name in both the upstream server definition and the `proxy_set_header Host` directive. The region code (e.g., `z20`) may vary depending on your storage account's region.{{< /call-out >}}

### Configuration breakdown

- **upstream storage_origin**: Defines the Azure Blob Storage static website endpoint as the backend server
- **keepalive 32**: Maintains persistent connections to the storage endpoint for better performance
- **location /static/**: Maps the `/static/` path on your NGINXaaS deployment to the `/content/` path in your static website
- **proxy_pass**: Forwards requests to the Azure Blob Storage endpoint with the `/content/` path
- **proxy_set_header Host**: Sets the correct Host header for the storage account
- **proxy_http_version 1.1**: Uses HTTP/1.1 for better connection reuse
- **proxy_set_header Connection ""**: Clears the connection header for proper keepalive behavior

## Upload the configuration

Upload your NGINX configuration to your NGINXaaS deployment following the instructions in the [NGINX configuration]({{< ref "/nginxaas-azure/getting-started/nginx-configuration/nginx-configuration-portal.md" >}}) documentation.

## Test the configuration

1. Browse to `https://<NGINXaaS IP>/static/<your-file-name>` to access your static content.
2. For example, if you have an `index.html` file in your `$web` container, access it via `https://<NGINXaaS IP>/static/index.html`.
3. Your content should be served from Azure Blob Storage through your NGINXaaS deployment.

## Verify traffic routing

You can verify that requests are properly routed through your NGINXaaS deployment by checking the Azure Storage logs:

1. Enable logging for your storage account if not already enabled.
2. In the storage logs, you should see requests coming from the private IP address of your NGINXaaS deployment, not from public Internet addresses.

## Benefits of this approach

- **No payload size limits**: Unlike local hosting, you're not limited by the 3 MB configuration payload size
- **Scalable storage**: Azure Blob Storage can handle large amounts of static content
- **Private access**: Your storage account remains private and is only accessible through your NGINXaaS deployment
- **Cost-effective**: Azure Blob Storage offers cost-effective storage for static content
- **Global availability**: Leverage Azure's global infrastructure for content delivery

## Limitations

- Requires network connectivity between your NGINXaaS deployment and the storage account
- Additional latency compared to locally hosted content due to the proxy pass to Azure Blob Storage
- Storage account must be in a region that allows network connectivity to your NGINXaaS deployment
