---
f5-files:
  - content/f5ads/google/deploy/create-deployment/deploy-terraform.md
  - content/f5ads/google/deploy/nginx-configuration/nginx-configuration-terraform.md
f5-product: F5 Application Delivery Service for Google Cloud
---

If you already configured the provider, use the same Terraform working directory. Otherwise, add the `f5ads` provider to your Terraform configuration and pin it to the exact alpha version:

```hcl
terraform {
  required_providers {
    f5ads = {
      source  = "F5Networks/f5ads"
      version = "0.1.0-alpha.7"
    }
  }
}

provider "f5ads" {
  geo = "us"
}
```

The provider needs your Application Delivery Service client credentials to authenticate. You can supply them in the provider block or with environment variables.

To supply credentials in the provider block, replace the previous provider block with the following example:

```hcl
provider "f5ads" {
  geo           = "us"
  client_id     = "your-client-id"
  client_secret = "your-client-secret"
}
```

Alternatively, set the following environment variables:

```shell
export F5ADS_GEO="us"
export F5ADS_CLIENT_ID="your-client-id"
export F5ADS_CLIENT_SECRET="your-client-secret"
```
