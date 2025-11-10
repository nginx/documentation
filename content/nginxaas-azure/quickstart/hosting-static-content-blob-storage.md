---
title: Hosting static content in Azure Blob Storage
weight: 210
toc: true
url: /nginxaas/azure/quickstart/hosting-static-content-blob-storage/
type:
- how-to
---

F5 NGINXaaS for Azure (NGINXaaS) can serve static content stored in Azure Blob Storage using private endpoints, ensuring maximum security by keeping your storage account completely inaccessible from the public Internet. This approach also eliminates the configuration payload size limitations of local hosting.

## Before you begin

- [An Azure Storage Account](https://learn.microsoft.com/en-us/azure/storage/common/storage-account-create)
- [An NGINXaaS for Azure deployment]({{< ref "/nginxaas-azure/getting-started/create-deployment" >}})
- [A virtual network with available subnet space for private endpoints](https://learn.microsoft.com/en-us/azure/virtual-network/quick-create-portal)
- Static content files to serve

## Configure Azure Blob Storage

### Upload static files to a container

Upload your static files to a container in your storage account. In this example, we'll use a container named `content`.

### Disable public network access

1. In your storage account, navigate to **Networking** under **Security + networking**.
1. Under **Public network access**, select **Disable**.
1. Click **Save**.

### Disable anonymous blob access

1. In your storage account, navigate to **Configuration** under **Settings**.
1. Find the **Allow Blob anonymous access** setting and set it to **Disabled**.
1. Click **Save**.

### Set container access level to private

1. Navigate to **Containers** under **Data management**.
1. Select your container (for example, `content`).
1. Click **Change access level**.
1. Set **Anonymous access level** to **Private (no anonymous access)**.
1. Click **OK**.

### Create a new subnet for private endpoint NICs

1. Navigate to your virtual network where NGINXaaS is deployed.
1. Go to **Subnets** under **Settings**.
1. Click **+ Subnet**.
1. Create a new subnet which will be used to assign IP address to your Private Endpoint NIC.
1. Make a note of the subnet name for the next step.

### Create a private endpoint

1. In your storage account, navigate to **Networking** under **Security + networking**.
1. Go to the **Private endpoint connections** tab.
1. Click **+ Private endpoint**.
1. Configure the private endpoint:
   - **Name**: Provide a descriptive name for the private endpoint
   - **Network Interface Name**: Provide a name for the network interface
   - **Target sub-resource**: Select **blob**
   - **Virtual network**: Select the same virtual network as your NGINXaaS deployment
   - **Subnet**: Select the subnet created in the previous step
   - **Private DNS integration**: Enable this option to automatically create DNS records

### Generate a Shared Access Signature (SAS) token

1. In your storage account, navigate to **Shared access signature** under **Security + networking**.
1. Configure the SAS token with minimal required permissions:
   - **Allowed services**: Check **Blob**
   - **Allowed resource types**: Check **Object**
   - **Allowed permissions**: Check **Read** only
   - **Start and expiry date/time**: Set appropriate validity period
   - **Allowed protocols**: Select **HTTPS only**
1. Click **Generate SAS and connection string**.
1. Copy the **SAS token** (the part starting with `?sv=`).

{{< call-out "important" >}}Store the SAS token securely and regenerate it regularly according to your security policies. Grant only the minimum permissions required for your use case.{{< /call-out >}}

## Configure NGINXaaS

Create an NGINX configuration that uses the private endpoint and SAS token to access your Azure Blob Storage. The following NGINX config points to the `content` directory with `/static/` location and uses the SAS token from the previous step to authorize requests to blob storage. The resolver is set to 168.63.129.16 which is the Azure internal DNS IP. It doesn't change. It resolves the storage account endpoint to the private endpoint IP configured earlier.

```nginx
user nginx;
worker_processes auto;
worker_rlimit_nofile 8192;
pid /run/nginx/nginx.pid;

error_log /var/log/nginx/error.log error;

http {
    upstream storage_origin {
        server your-storage-account.blob.core.windows.net:443;
        keepalive 32;
    }
    resolver 168.63.129.16 valid=10s;
    server {
        listen 443 ssl;
        set $sas_token '?sv=YYYY-MM-DD&ss=b&srt=o&sp=r&se=YYYY-MM-DDTHH:MM:SSZ&st=YYYY-MM-DDTHH:MM:SSZ&spr=https&sig=YOUR_SAS_SIGNATURE_HERE';
        ssl_certificate /etc/nginx/example.cert;
        ssl_certificate_key /etc/nginx/example.key;
        location /static/ {
            rewrite ^/static/(.*)$ /content/$1 break;
            proxy_pass https://storage_origin$uri$sas_token;
            proxy_set_header Host your-storage-account.blob.core.windows.net;
            proxy_http_version 1.1;
            proxy_set_header Connection "";
        }
    }
}
```

{{< call-out "important" >}}Replace the following placeholders:
- `your-storage-account` with your actual storage account name
- `YOUR_SAS_SIGNATURE_HERE` with your actual SAS token signature
- Update the SAS token parameters according to your generated token{{< /call-out >}}

### Configuration breakdown

{{<table>}}
| Directive | Description |
|------------|-------------|
| **upstream storage_origin** | Defines the Azure Blob Storage endpoint as the backend server |
| **resolver 168.63.129.16** | Uses Azure's internal DNS resolver to resolve the storage account to the private endpoint IP |
| **set $sas_token** | Stores the SAS token for authorization |
| **rewrite** | Maps the `/static/` path to the `/content/` container in blob storage |
| **proxy_pass** | Forwards requests to the storage account with the SAS token appended |
| **keepalive 32** | Maintains persistent connections for better performance |
{{</table>}}

## Upload the configuration

Upload your NGINX configuration to your NGINXaaS deployment following the instructions in the [NGINX configuration]({{< ref "/nginxaas-azure/getting-started/nginx-configuration/nginx-configuration-portal.md" >}}) documentation.

## Test the configuration

1. Go to `https://<NGINXaaS IP>/static/<your-file-name>` to access your static content.
1. For example, if you have an `index.html` file in your `content` container, access it via `https://<NGINXaaS IP>/static/index.html`.
1. Your content should be served from Azure Blob Storage through the private endpoint.

## Verify private endpoint connectivity

You can verify that traffic flows through the private endpoint by checking that:

1. The storage account is completely inaccessible from the public Internet
1. DNS resolution of your storage account resolves to the private IP address of the private endpoint
1. Network traffic flows through your virtual network without traversing the public Internet

## Benefits of this approach

- **Maximum security**: Storage account is completely private with no public Internet access
- **No payload size limits**: Unlike local hosting, you're not limited by the 3 MB configuration payload size
- **Scalable storage**: Azure Blob Storage can handle large amounts of static content
- **Network isolation**: All traffic flows through your private virtual network
- **Cost-effective**: Azure Blob Storage offers cost-effective storage for static content
- **Controlled access**: SAS tokens provide fine-grained access control with expiration

## Security considerations

- **SAS token management**: Regularly rotate SAS tokens and grant minimal required permissions
- **Network isolation**: Ensure private endpoints are properly configured in isolated subnets
- **Access monitoring**: Enable logging and monitoring for storage account access
- **Principle of least privilege**: Grant only the minimum permissions necessary for your use case

## Limitations

- Requires private endpoint configuration and additional subnet space
- SAS tokens need regular rotation and management
- Additional complexity compared to public access methods
- Private endpoint incurs additional Azure networking costs
